using Microsoft.Data.SqlClient;
using System.Text;
using System.Text.RegularExpressions;

namespace pg_converter_ui;

public static class MssqlDbReader
{
    public static string BuildConnectionString(
        string server, string database, bool winAuth, string user, string pass) =>
        winAuth
            ? $"Server={server};Database={database};Integrated Security=True;TrustServerCertificate=True;Connect Timeout=15;"
            : $"Server={server};Database={database};User Id={user};Password={pass};TrustServerCertificate=True;Connect Timeout=15;";

    public static (List<DbObject> objects, string error) Load(
        string server, string database, bool winAuth, string user, string pass,
        bool inclFunc, bool inclTable, bool inclIndex)
    {
        var authMode = winAuth ? "Windows Auth" : "SQL Auth";
        Logger.Section($"Load DB  {server}/{database}  [{authMode}]");

        var cs = BuildConnectionString(server, database, winAuth, user, pass);
        try
        {
            var result = new List<DbObject>();
            using var conn = new SqlConnection(cs);
            conn.Open();
            Logger.Info("Connection opened");

            if (inclFunc)
            {
                Logger.Info("Loading functions/procedures/views...");
                var fns = LoadRoutinesAndViews(conn);
                Logger.Info($"Loaded {fns.Count} routines/views");
                result.AddRange(fns);
            }
            if (inclTable)
            {
                Logger.Info("Loading tables...");
                var tbs = LoadTables(conn);
                Logger.Info($"Loaded {tbs.Count} tables");
                result.AddRange(tbs);

                // Load foreign key constraints after tables
                try
                {
                    Logger.Info("Loading foreign keys...");
                    var fks = LoadForeignKeys(conn);
                    Logger.Info($"Loaded {fks.Count} foreign keys");
                    result.AddRange(fks);
                }
                catch (Exception ex)
                {
                    Logger.Warn($"LoadForeignKeys skipped: {ex.Message}");
                }
            }
            if (inclIndex)
            {
                Logger.Info("Loading indexes...");
                var ixs = LoadIndexes(conn);
                Logger.Info($"Loaded {ixs.Count} indexes");
                result.AddRange(ixs);
            }

            Logger.Info($"Total loaded: {result.Count} objects");
            return (result, "");
        }
        catch (Exception ex)
        {
            Logger.Error($"Load failed: {server}/{database}", ex);
            return (new List<DbObject>(), ex.Message);
        }
    }

    // ── Functions / Stored Procedures / Views ─────────────────────────────────

    static List<DbObject> LoadRoutinesAndViews(SqlConnection conn)
    {
        const string sql = @"
            SELECT o.name, o.type, sm.definition
            FROM sys.sql_modules sm
            JOIN sys.objects o ON sm.object_id = o.object_id
            WHERE o.type IN ('P ','P','FN','TF','IF','V ')
              AND o.schema_id = SCHEMA_ID('dbo')
            ORDER BY o.name";

        var result = new List<DbObject>();
        using var cmd = new SqlCommand(sql, conn);
        cmd.CommandTimeout = 60;
        using var rdr = cmd.ExecuteReader();
        while (rdr.Read())
        {
            try
            {
                var name = rdr.GetString(0);
                var type = rdr.GetString(1).Trim();
                var def  = rdr.IsDBNull(2)
                    ? $"CREATE PROCEDURE [dbo].[{name}] AS BEGIN RETURN; END"
                    : rdr.GetString(2);
                var complex = IsComplexBody(def);
                ObjectType objType;
                if (type.Equals("P", StringComparison.OrdinalIgnoreCase))
                    objType = ObjectType.Procedure;
                else if (type.Equals("V", StringComparison.OrdinalIgnoreCase))
                    objType = ObjectType.View;
                else
                    objType = ObjectType.Function;

                result.Add(new DbObject(name, objType, def, complex, complex ? "STUB" : "OK"));
            }
            catch (Exception ex)
            {
                Logger.Warn($"LoadRoutinesAndViews: skipping row — {ex.Message}");
            }
        }
        return result;
    }

    static bool IsComplexBody(string def) => BodyConverter.IsTrueStub(def);

    // ── Tables ────────────────────────────────────────────────────────────────

    static List<DbObject> LoadTables(SqlConnection conn)
    {
        const string sql = @"
            SELECT
                t.name                                       AS TableName,
                c.name                                       AS ColName,
                tp.name                                      AS TypeName,
                CASE
                    WHEN tp.name IN ('nvarchar','nchar')
                         THEN CASE WHEN c.max_length = -1 THEN 'MAX'
                                   ELSE CAST(c.max_length / 2 AS varchar) END
                    WHEN tp.name IN ('varchar','char','binary','varbinary')
                         THEN CASE WHEN c.max_length = -1 THEN 'MAX'
                                   ELSE CAST(c.max_length AS varchar) END
                    ELSE NULL
                END                                          AS Size,
                c.precision,
                c.scale,
                c.is_nullable,
                c.is_identity,
                CASE WHEN pk.column_id IS NOT NULL THEN 1 ELSE 0 END AS IsPK,
                c.column_id,
                dc.definition                                AS DefaultDef
            FROM sys.tables t
            JOIN sys.columns c  ON t.object_id = c.object_id
            JOIN sys.types   tp ON c.user_type_id = tp.user_type_id
            LEFT JOIN (
                SELECT ic.object_id, ic.column_id
                FROM sys.index_columns ic
                JOIN sys.indexes i ON ic.object_id = i.object_id
                                   AND ic.index_id = i.index_id
                WHERE i.is_primary_key = 1
            ) pk ON pk.object_id = t.object_id AND pk.column_id = c.column_id
            LEFT JOIN sys.default_constraints dc
                ON dc.parent_object_id = t.object_id
               AND dc.parent_column_id = c.column_id
            WHERE t.schema_id = SCHEMA_ID('dbo')
              AND t.is_ms_shipped = 0
            ORDER BY t.name, c.column_id";

        var tables = new Dictionary<string, List<ColumnInfo>>(StringComparer.OrdinalIgnoreCase);
        using var cmd = new SqlCommand(sql, conn);
        cmd.CommandTimeout = 60;
        using var rdr = cmd.ExecuteReader();
        while (rdr.Read())
        {
            var tbl = rdr.GetString(0);
            if (!tables.ContainsKey(tbl)) tables[tbl] = new List<ColumnInfo>();
            tables[tbl].Add(new ColumnInfo(
                Name:         rdr.GetString(1),
                TypeName:     rdr.GetString(2),
                Size:         rdr.IsDBNull(3) ? null : rdr.GetString(3),
                Precision:    rdr.GetByte(4),
                Scale:        rdr.GetByte(5),
                IsNullable:   rdr.GetBoolean(6),
                IsIdentity:   rdr.GetBoolean(7),
                IsPrimaryKey: rdr.GetInt32(8) == 1,
                DefaultValue: rdr.IsDBNull(10) ? null : rdr.GetString(10)
            ));
        }

        return tables.Select(kv =>
        {
            return new DbObject(kv.Key, ObjectType.Table, BuildTableRaw(kv.Key, kv.Value), false, "OK");
        }).ToList();
    }

    static string BuildTableRaw(string tableName, List<ColumnInfo> cols)
    {
        var sb = new StringBuilder();
        sb.AppendLine($"__TABLE_FROM_CATALOG__ {tableName}");
        foreach (var c in cols)
            sb.AppendLine($"COL|{c.Name}|{c.TypeName}|{c.Size ?? ""}|{c.Precision}|{c.Scale}|{c.IsNullable}|{c.IsIdentity}|{c.IsPrimaryKey}|{c.DefaultValue ?? ""}");
        return sb.ToString();
    }

    public static List<ColumnInfo> ParseTableRaw(string raw)
    {
        var result = new List<ColumnInfo>();
        foreach (var line in raw.Split('\n'))
        {
            if (!line.StartsWith("COL|")) continue;
            var p = line.Trim().Split('|');
            if (p.Length < 9) continue;
            result.Add(new ColumnInfo(
                Name:         p[1],
                TypeName:     p[2],
                Size:         string.IsNullOrEmpty(p[3]) ? null : p[3],
                Precision:    int.TryParse(p[4], out var pr) ? pr : 0,
                Scale:        int.TryParse(p[5], out var sc) ? sc : 0,
                IsNullable:   p[6] == "True",
                IsIdentity:   p[7] == "True",
                IsPrimaryKey: p[8].Trim() == "True",
                DefaultValue: p.Length >= 10 && !string.IsNullOrEmpty(p[9]) ? p[9].Trim() : null
            ));
        }
        return result;
    }

    // ── Foreign Keys ──────────────────────────────────────────────────────────

    static List<DbObject> LoadForeignKeys(SqlConnection conn)
    {
        // STUFF+FOR XML PATH works on SQL Server 2008+
        const string sql = @"
            SELECT
                fk.name AS FKName,
                OBJECT_NAME(fk.parent_object_id) AS ChildTable,
                STUFF((
                    SELECT ',' + pc.name
                    FROM sys.foreign_key_columns fkc2
                    JOIN sys.columns pc ON fkc2.parent_object_id = pc.object_id
                                      AND fkc2.parent_column_id = pc.column_id
                    WHERE fkc2.constraint_object_id = fk.object_id
                    ORDER BY fkc2.constraint_column_id
                    FOR XML PATH('')
                ), 1, 1, '') AS ChildCols,
                OBJECT_NAME(fk.referenced_object_id) AS ParentTable,
                STUFF((
                    SELECT ',' + rc.name
                    FROM sys.foreign_key_columns fkc2
                    JOIN sys.columns rc ON fkc2.referenced_object_id = rc.object_id
                                      AND fkc2.referenced_column_id = rc.column_id
                    WHERE fkc2.constraint_object_id = fk.object_id
                    ORDER BY fkc2.constraint_column_id
                    FOR XML PATH('')
                ), 1, 1, '') AS ParentCols,
                fk.delete_referential_action_desc,
                fk.update_referential_action_desc
            FROM sys.foreign_keys fk
            JOIN sys.objects t ON fk.parent_object_id = t.object_id
            WHERE t.schema_id = SCHEMA_ID('dbo')
              AND t.is_ms_shipped = 0
            ORDER BY fk.name";

        var result = new List<DbObject>();
        using var cmd = new SqlCommand(sql, conn);
        cmd.CommandTimeout = 60;
        using var rdr = cmd.ExecuteReader();
        while (rdr.Read())
        {
            if (rdr.IsDBNull(0)) continue;
            var fkName    = rdr.GetString(0);
            var childTbl  = rdr.GetString(1);
            var childCols = rdr.IsDBNull(2) ? "" : rdr.GetString(2);
            var parentTbl = rdr.GetString(3);
            var parentCols= rdr.IsDBNull(4) ? "" : rdr.GetString(4);
            var onDelete  = rdr.IsDBNull(5) ? "NO_ACTION" : rdr.GetString(5);
            var onUpdate  = rdr.IsDBNull(6) ? "NO_ACTION" : rdr.GetString(6);
            var raw = $"__FK_CONSTRAINT__{fkName}|{childTbl}|{childCols}|{parentTbl}|{parentCols}|{onDelete}|{onUpdate}";
            result.Add(new DbObject(fkName, ObjectType.Constraint, raw, false, "OK"));
        }
        return result;
    }

    // ── Indexes ───────────────────────────────────────────────────────────────

    static List<DbObject> LoadIndexes(SqlConnection conn)
    {
        // STUFF+FOR XML PATH works on SQL Server 2008+
        const string sql = @"
            SELECT
                i.name AS IndexName,
                t.name AS TableName,
                i.is_unique,
                i.type_desc,
                STUFF((
                    SELECT ', ' + c2.name + CASE ic2.is_descending_key WHEN 1 THEN ' DESC' ELSE '' END
                    FROM sys.index_columns ic2
                    JOIN sys.columns c2 ON ic2.object_id = c2.object_id
                                       AND ic2.column_id = c2.column_id
                    WHERE ic2.object_id = i.object_id
                      AND ic2.index_id  = i.index_id
                      AND ic2.is_included_column = 0
                    ORDER BY ic2.key_ordinal
                    FOR XML PATH('')
                ), 1, 2, '') AS KeyCols,
                STUFF((
                    SELECT ', ' + c2.name
                    FROM sys.index_columns ic2
                    JOIN sys.columns c2 ON ic2.object_id = c2.object_id
                                       AND ic2.column_id = c2.column_id
                    WHERE ic2.object_id = i.object_id
                      AND ic2.index_id  = i.index_id
                      AND ic2.is_included_column = 1
                    ORDER BY ic2.key_ordinal
                    FOR XML PATH('')
                ), 1, 2, '') AS InclCols,
                i.filter_definition AS FilterDef
            FROM sys.indexes i
            JOIN sys.tables  t ON i.object_id = t.object_id
            WHERE i.type > 0
              AND i.is_primary_key       = 0
              AND i.is_unique_constraint = 0
              AND t.schema_id = SCHEMA_ID('dbo')
              AND t.is_ms_shipped = 0
            ORDER BY t.name, i.name";

        var result = new List<DbObject>();
        using var cmd = new SqlCommand(sql, conn);
        cmd.CommandTimeout = 60;
        using var rdr = cmd.ExecuteReader();
        while (rdr.Read())
        {
            if (rdr.IsDBNull(0)) continue;
            var idxName  = rdr.GetString(0);
            var tblName  = rdr.GetString(1);
            var isUnique = rdr.GetBoolean(2);
            var typeDesc = rdr.IsDBNull(3) ? "NONCLUSTERED" : rdr.GetString(3);
            var keyCols  = rdr.IsDBNull(4) ? "" : rdr.GetString(4);
            var inclCols = rdr.IsDBNull(5) ? "" : rdr.GetString(5);
            var filterDef= rdr.IsDBNull(6) ? "" : rdr.GetString(6);

            var unique    = isUnique ? "UNIQUE " : "";
            var clustered = typeDesc.Equals("CLUSTERED", StringComparison.OrdinalIgnoreCase) ? "CLUSTERED " : "NONCLUSTERED ";
            var inclPart  = string.IsNullOrEmpty(inclCols) ? "" : $" INCLUDE ({inclCols})";
            var wherePart = string.IsNullOrEmpty(filterDef) ? "" : $" WHERE {filterDef}";
            var raw = $"CREATE {unique}{clustered}INDEX [{idxName}] ON [dbo].[{tblName}] ({keyCols}){inclPart}{wherePart}";
            result.Add(new DbObject(idxName, ObjectType.Index, raw, false, "OK"));
        }
        return result;
    }
}
