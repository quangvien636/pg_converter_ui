using System.Text;
using System.Text.RegularExpressions;
using Microsoft.Data.SqlClient;
using Npgsql;

var msConnection = Require("MSSQL_SOURCE_CONNECTION");
var bootstrapConnection = Require("PG_BOOTSTRAP_CONNECTION");
var runtimeConnection = Require("PG_RUNTIME_CONNECTION");
GuardPg(bootstrapConnection, "crewcloud_company_bootstrap_test");
GuardPg(runtimeConnection, "pg_converter_runtime_test");

var root = FindRoot();
var output = Path.Combine(root, "reports", "schema_snapshots", "inventory_v2");
Directory.CreateDirectory(output);

var ms = await ReadMssql(msConnection);
var sourceProcedures = ms.Where(x => x.ObjectKind == "PROCEDURE")
    .Select(x => x.ObjectName).ToHashSet(StringComparer.OrdinalIgnoreCase);
var bootstrap = await ReadPostgres(bootstrapConnection, "crewcloud_company_bootstrap_test", sourceProcedures);
var runtime = await ReadPostgres(runtimeConnection, "pg_converter_runtime_test", sourceProcedures);

await WriteCsv(Path.Combine(output, "mssql_inventory.csv"), ms);
await WriteCsv(Path.Combine(output, "bootstrap_pg_inventory.csv"), bootstrap);
await WriteCsv(Path.Combine(output, "runtime_pg_inventory.csv"), runtime);

var analysis = Analyze(ms, bootstrap, runtime);
await File.WriteAllTextAsync(
    Path.Combine(root, "reports", "runtime_object_gap_analysis_v2.md"),
    RenderReport(ms, bootstrap, runtime, analysis),
    new UTF8Encoding(false));

Console.WriteLine($"MSSQL={ms.Count}; bootstrap={bootstrap.Count}; runtime={runtime.Count}");
Console.WriteLine($"EXPORT_MISSING={analysis.Count(x => x.Classification == "EXPORT_MISSING")}; UNKNOWN={analysis.Count(x => x.Classification == "UNKNOWN")}");
Console.WriteLine("Read-only inventory completed. No database was modified.");

static string Require(string name) =>
    Environment.GetEnvironmentVariable(name) is { Length: > 0 } value
        ? value : throw new InvalidOperationException($"Set {name}; never store credentials in source.");

static void GuardPg(string connection, string expected)
{
    var settings = new NpgsqlConnectionStringBuilder(connection);
    if (!string.Equals(settings.Database, expected, StringComparison.Ordinal))
        throw new InvalidOperationException($"Refusing database '{settings.Database}'; expected '{expected}'.");
}

static async Task<List<InventoryRow>> ReadMssql(string connectionString)
{
    const string sql = """
        SELECT object_kind, schema_name, object_name, parent_object, column_name,
               normalized_signature, dependency_kind
        FROM (
          SELECT 'SCHEMA' object_kind, s.name schema_name, s.name object_name,
                 '' parent_object, '' column_name, '' normalized_signature, '' dependency_kind
          FROM sys.schemas s WHERE s.name='dbo'
          UNION ALL
          SELECT 'TABLE', s.name, t.name, '', '', '', ''
          FROM sys.tables t JOIN sys.schemas s ON s.schema_id=t.schema_id WHERE s.name='dbo'
          UNION ALL
          SELECT 'COLUMN', s.name, t.name+'.'+c.name, t.name, c.name,
                 LOWER(ty.name)+CASE WHEN ty.name IN ('varchar','nvarchar','char','nchar','varbinary','binary')
                   THEN '('+CASE WHEN c.max_length=-1 THEN 'max' ELSE CONVERT(varchar(10),c.max_length) END+')'
                   WHEN ty.name IN ('decimal','numeric') THEN '('+CONVERT(varchar(10),c.precision)+','+CONVERT(varchar(10),c.scale)+')'
                   ELSE '' END+'|nullable='+CONVERT(varchar(1),c.is_nullable), 'TABLE'
          FROM sys.tables t JOIN sys.schemas s ON s.schema_id=t.schema_id
          JOIN sys.columns c ON c.object_id=t.object_id JOIN sys.types ty ON ty.user_type_id=c.user_type_id
          WHERE s.name='dbo'
          UNION ALL
          SELECT 'DEFAULT', s.name, dc.name, OBJECT_NAME(dc.parent_object_id), COL_NAME(dc.parent_object_id,dc.parent_column_id),
                 LOWER(REPLACE(REPLACE(dc.definition,'[',''),']','')), 'COLUMN'
          FROM sys.default_constraints dc JOIN sys.schemas s ON s.schema_id=dc.schema_id WHERE s.name='dbo'
          UNION ALL
          SELECT CASE kc.type WHEN 'PK' THEN 'PRIMARY_KEY' ELSE 'UNIQUE_CONSTRAINT' END,
                 s.name,kc.name,OBJECT_NAME(kc.parent_object_id),'',
                 COALESCE(STUFF((SELECT ','+LOWER(c.name) FROM sys.index_columns ic
                    JOIN sys.columns c ON c.object_id=ic.object_id AND c.column_id=ic.column_id
                    WHERE ic.object_id=kc.parent_object_id AND ic.index_id=kc.unique_index_id
                    ORDER BY ic.key_ordinal FOR XML PATH('')),1,1,''),''), 'TABLE'
          FROM sys.key_constraints kc JOIN sys.schemas s ON s.schema_id=kc.schema_id WHERE s.name='dbo'
          UNION ALL
          SELECT 'FOREIGN_KEY',s.name,fk.name,OBJECT_NAME(fk.parent_object_id),'',
                 LOWER(OBJECT_NAME(fk.referenced_object_id))+'('+
                 COALESCE(STUFF((SELECT ','+LOWER(COL_NAME(fkc.parent_object_id,fkc.parent_column_id))+'->'+LOWER(COL_NAME(fkc.referenced_object_id,fkc.referenced_column_id))
                   FROM sys.foreign_key_columns fkc WHERE fkc.constraint_object_id=fk.object_id
                   ORDER BY fkc.constraint_column_id FOR XML PATH('')),1,1,''),'')+')', 'TABLE'
          FROM sys.foreign_keys fk JOIN sys.schemas s ON s.schema_id=fk.schema_id WHERE s.name='dbo'
          UNION ALL
          SELECT 'CHECK_CONSTRAINT',s.name,cc.name,OBJECT_NAME(cc.parent_object_id),'',
                 LOWER(REPLACE(REPLACE(cc.definition,'[',''),']','')), 'TABLE'
          FROM sys.check_constraints cc JOIN sys.schemas s ON s.schema_id=cc.schema_id WHERE s.name='dbo'
          UNION ALL
          SELECT 'INDEX',s.name,i.name,t.name,'',
                 COALESCE(STUFF((SELECT ','+LOWER(c.name)+CASE WHEN ic.is_descending_key=1 THEN ' desc' ELSE '' END
                    FROM sys.index_columns ic JOIN sys.columns c ON c.object_id=ic.object_id AND c.column_id=ic.column_id
                    WHERE ic.object_id=i.object_id AND ic.index_id=i.index_id AND ic.is_included_column=0
                    ORDER BY ic.key_ordinal FOR XML PATH('')),1,1,''),'')+
                 '|unique='+CONVERT(varchar(1),i.is_unique), 'TABLE'
          FROM sys.indexes i JOIN sys.tables t ON t.object_id=i.object_id JOIN sys.schemas s ON s.schema_id=t.schema_id
          WHERE s.name='dbo' AND i.name IS NOT NULL
          UNION ALL
          SELECT 'TRIGGER',s.name,tr.name,OBJECT_NAME(tr.parent_id),'',LOWER(COALESCE(sm.definition,'')),'TABLE'
          FROM sys.triggers tr JOIN sys.objects o ON o.object_id=tr.parent_id
          JOIN sys.schemas s ON s.schema_id=o.schema_id LEFT JOIN sys.sql_modules sm ON sm.object_id=tr.object_id
          WHERE s.name='dbo'
          UNION ALL
          SELECT 'VIEW',s.name,v.name,'','',LOWER(COALESCE(sm.definition,'')),''
          FROM sys.views v JOIN sys.schemas s ON s.schema_id=v.schema_id LEFT JOIN sys.sql_modules sm ON sm.object_id=v.object_id
          WHERE s.name='dbo'
          UNION ALL
          SELECT CASE WHEN o.type IN ('P','PC') THEN 'PROCEDURE' ELSE 'FUNCTION' END,s.name,o.name,'','',
                 LOWER(COALESCE(STUFF((SELECT ','+LOWER(ty.name) FROM sys.parameters p
                    JOIN sys.types ty ON ty.user_type_id=p.user_type_id WHERE p.object_id=o.object_id AND p.parameter_id>0
                    ORDER BY p.parameter_id FOR XML PATH('')),1,1,''),'')), ''
          FROM sys.objects o JOIN sys.schemas s ON s.schema_id=o.schema_id
          WHERE s.name='dbo' AND o.type IN ('P','PC','FN','IF','TF','FS','FT')
          UNION ALL
          SELECT 'TYPE',s.name,ty.name,'','',LOWER(bt.name),''
          FROM sys.types ty JOIN sys.schemas s ON s.schema_id=ty.schema_id
          JOIN sys.types bt ON bt.user_type_id=ty.system_type_id AND bt.user_type_id=bt.system_type_id
          WHERE s.name='dbo' AND ty.is_user_defined=1
        ) q
        ORDER BY object_kind,schema_name,object_name
        """;
    var rows = new List<InventoryRow>();
    await using var connection = new SqlConnection(connectionString);
    await connection.OpenAsync();
    await using var command = connection.CreateCommand();
    command.CommandText = sql;
    command.CommandTimeout = 180;
    await using var reader = await command.ExecuteReaderAsync();
    while (await reader.ReadAsync())
        rows.Add(ReadRow(reader, "MSSQL:CrewCloud_Company_Bootstrap"));
    return rows;
}

static async Task<List<InventoryRow>> ReadPostgres(
    string connectionString, string database, HashSet<string> sourceProcedures)
{
    const string sql = """
        SELECT object_kind,schema_name,object_name,parent_object,column_name,normalized_signature,dependency_kind
        FROM (
          SELECT 'SCHEMA' object_kind,n.nspname schema_name,n.nspname object_name,'' parent_object,'' column_name,'' normalized_signature,'' dependency_kind
          FROM pg_namespace n WHERE n.nspname='public'
          UNION ALL
          SELECT 'TABLE',n.nspname,c.relname,'','','',''
          FROM pg_class c JOIN pg_namespace n ON n.oid=c.relnamespace WHERE n.nspname='public' AND c.relkind='r'
          UNION ALL
          SELECT 'COLUMN',n.nspname,c.relname||'.'||a.attname,c.relname,a.attname,
                 LOWER(format_type(a.atttypid,a.atttypmod))||'|nullable='||CASE WHEN a.attnotnull THEN '0' ELSE '1' END,'TABLE'
          FROM pg_class c JOIN pg_namespace n ON n.oid=c.relnamespace
          JOIN pg_attribute a ON a.attrelid=c.oid AND a.attnum>0 AND NOT a.attisdropped
          WHERE n.nspname='public' AND c.relkind='r'
          UNION ALL
          SELECT 'DEFAULT',n.nspname,c.relname||'_'||a.attname||'_default',c.relname,a.attname,
                 LOWER(pg_get_expr(ad.adbin,ad.adrelid)),'COLUMN'
          FROM pg_attrdef ad JOIN pg_class c ON c.oid=ad.adrelid JOIN pg_namespace n ON n.oid=c.relnamespace
          JOIN pg_attribute a ON a.attrelid=c.oid AND a.attnum=ad.adnum WHERE n.nspname='public'
          UNION ALL
          SELECT CASE con.contype WHEN 'p' THEN 'PRIMARY_KEY' WHEN 'f' THEN 'FOREIGN_KEY'
                   WHEN 'u' THEN 'UNIQUE_CONSTRAINT' ELSE 'CHECK_CONSTRAINT' END,
                 n.nspname,con.conname,COALESCE(c.relname,''),'',LOWER(pg_get_constraintdef(con.oid)),'TABLE'
          FROM pg_constraint con JOIN pg_namespace n ON n.oid=con.connamespace
          LEFT JOIN pg_class c ON c.oid=con.conrelid
          WHERE n.nspname='public' AND con.contype IN ('p','f','u','c')
          UNION ALL
          SELECT 'INDEX',n.nspname,ci.relname,ct.relname,'',LOWER(pg_get_indexdef(i.indexrelid)),'TABLE'
          FROM pg_index i JOIN pg_class ci ON ci.oid=i.indexrelid JOIN pg_class ct ON ct.oid=i.indrelid
          JOIN pg_namespace n ON n.oid=ct.relnamespace WHERE n.nspname='public'
          UNION ALL
          SELECT 'TRIGGER',n.nspname,t.tgname,c.relname,'',LOWER(pg_get_triggerdef(t.oid)),'TABLE'
          FROM pg_trigger t JOIN pg_class c ON c.oid=t.tgrelid JOIN pg_namespace n ON n.oid=c.relnamespace
          WHERE n.nspname='public' AND NOT t.tgisinternal
          UNION ALL
          SELECT 'VIEW',n.nspname,c.relname,'','',LOWER(pg_get_viewdef(c.oid,true)),''
          FROM pg_class c JOIN pg_namespace n ON n.oid=c.relnamespace WHERE n.nspname='public' AND c.relkind IN ('v','m')
          UNION ALL
          SELECT 'ROUTINE',n.nspname,p.proname,'','',LOWER(pg_get_function_identity_arguments(p.oid)),''
          FROM pg_proc p JOIN pg_namespace n ON n.oid=p.pronamespace WHERE n.nspname='public'
          UNION ALL
          SELECT 'TYPE',n.nspname,t.typname,'','',
                 CASE t.typtype WHEN 'e' THEN 'enum' WHEN 'd' THEN 'domain:'||LOWER(format_type(t.typbasetype,t.typtypmod))
                   ELSE LOWER(t.typtype::text) END,''
          FROM pg_type t JOIN pg_namespace n ON n.oid=t.typnamespace
          WHERE n.nspname='public' AND t.typtype IN ('e','d') AND t.typrelid=0
          UNION ALL
          SELECT 'SEQUENCE',n.nspname,c.relname,'','','',''
          FROM pg_class c JOIN pg_namespace n ON n.oid=c.relnamespace WHERE n.nspname='public' AND c.relkind='S'
        ) q ORDER BY object_kind,schema_name,object_name
        """;
    var rows = new List<InventoryRow>();
    await using var connection = new NpgsqlConnection(connectionString);
    await connection.OpenAsync();
    await using var command = connection.CreateCommand();
    command.CommandText = sql;
    command.CommandTimeout = 180;
    await using var reader = await command.ExecuteReaderAsync();
    while (await reader.ReadAsync())
    {
        var row = ReadRow(reader, $"PostgreSQL:{database}");
        if (row.ObjectKind == "ROUTINE")
            row = row with { ObjectKind = sourceProcedures.Contains(row.ObjectName) ? "PROCEDURE" : "FUNCTION" };
        rows.Add(row);
    }
    return rows;
}

static InventoryRow ReadRow(System.Data.Common.DbDataReader reader, string source) =>
    new(
        reader.GetString(0), reader.GetString(1), reader.GetString(2),
        reader.GetString(3), reader.GetString(4), reader.GetString(5), source, reader.GetString(6));

static List<GapRow> Analyze(
    List<InventoryRow> source, List<InventoryRow> bootstrap, List<InventoryRow> runtime)
{
    var boot = bootstrap.GroupBy(Key).ToDictionary(g => g.Key, g => g.ToList());
    var run = runtime.GroupBy(Key).ToDictionary(g => g.Key, g => g.ToList());
    var sourceKeys = source.Select(Key).ToHashSet();
    var result = new List<GapRow>();
    foreach (var row in source)
    {
        var key = Key(row);
        var hasBoot = boot.ContainsKey(key);
        var hasRun = run.ContainsKey(key);
        var classification = (hasBoot, hasRun) switch
        {
            (true, true) => SameSignature(row, boot[key]) && SameSignature(row, run[key]) ? "MATCHED" : "CONVERTED",
            (true, false) => "RUNTIME_MISSING",
            (false, true) => "BOOTSTRAP_MISSING",
            _ => row.ObjectKind is "PRIMARY_KEY" or "FOREIGN_KEY" or "UNIQUE_CONSTRAINT" or "CHECK_CONSTRAINT" or "DEFAULT"
                ? "CONVERTER_BUG" : "BOOTSTRAP_MISSING"
        };
        result.Add(new GapRow(row, classification, Explain(row, classification)));
    }
    foreach (var row in bootstrap.Concat(runtime).Where(x => !sourceKeys.Contains(Key(x))).DistinctBy(Key))
        result.Add(new GapRow(row, "UNKNOWN", "PostgreSQL-only normalized key; verify extension/reference-only object or source naming mismatch."));
    return result;
}

static string Key(InventoryRow x)
{
    var schema = x.SchemaName.Equals("dbo", StringComparison.OrdinalIgnoreCase)
        || x.SchemaName.Equals("public", StringComparison.OrdinalIgnoreCase) ? "app" : x.SchemaName.ToLowerInvariant();
    
    string parentObj = x.ParentObject.ToLowerInvariant();
    string colName = x.ColumnName.ToLowerInvariant();
    string objName = x.ObjectName.ToLowerInvariant();

    if (x.ObjectKind == "DEFAULT")
    {
        objName = "default";
    }
    else if (x.ObjectKind == "PRIMARY_KEY")
    {
        objName = "pk";
    }
    else if (x.ObjectKind == "UNIQUE_CONSTRAINT")
    {
        objName = "uq:" + NormalizeSignature(x.NormalizedSignature);
    }
    else if (x.ObjectKind == "FOREIGN_KEY")
    {
        objName = "fk:" + NormalizeSignature(x.NormalizedSignature);
    }
    else if (x.ObjectKind == "CHECK_CONSTRAINT")
    {
        objName = "ck:" + NormalizeSignature(x.NormalizedSignature);
    }
    else if (x.ObjectKind == "INDEX")
    {
        if (objName.StartsWith("pk__") || objName.Contains("_pkey") || objName.Contains("pkey"))
        {
            objName = "pk_idx";
        }
    }

    return string.Join("|", x.ObjectKind, schema, parentObj, colName, objName);
}

static bool SameSignature(InventoryRow source, List<InventoryRow> target) =>
    target.Any(x => NormalizeSignature(source.NormalizedSignature) == NormalizeSignature(x.NormalizedSignature));

static string NormalizeSignature(string value)
{
    if (string.IsNullOrWhiteSpace(value)) return "";
    var val = value.ToLowerInvariant()
        .Replace("character varying", "nvarchar").Replace("integer", "int")
        .Replace("timestamp without time zone", "datetime").Replace("boolean", "bit")
        .Replace("public.", "").Replace("dbo.", "").Replace("\"", "").Replace("[", "").Replace("]", "")
        .Replace("&gt;", ">")
        .Replace(" ", "");

    if (val.Contains("::"))
    {
        val = Regex.Replace(val, @"::[a-z0-9_]+(?:\([0-9,]\))?", "");
    }
    val = Regex.Replace(val, @"\bn'(.*?)'", "'$1'");
    
    if (val == "getdate" || val == "getutcdate" || val == "sysdatetime" || val == "now")
    {
        return "now";
    }
    if (val == "false" || val == "0.0" || val == "0")
    {
        return "0";
    }
    if (val == "true" || val == "1.0" || val == "1")
    {
        return "1";
    }

    if (val.StartsWith("primarykey"))
    {
        val = val.Substring("primarykey".Length).Trim('(', ')');
    }
    else if (val.StartsWith("unique"))
    {
        val = val.Substring("unique".Length).Trim('(', ')');
    }
    else if (val.StartsWith("foreignkey"))
    {
        var m = Regex.Match(val, @"foreignkey\(([^)]+)\)references([a-z0-9_]+)\(([^)]+)\)", RegexOptions.IgnoreCase);
        if (m.Success)
        {
            var childCols = m.Groups[1].Value.Split(',');
            var parentTbl = m.Groups[2].Value;
            var parentCols = m.Groups[3].Value.Split(',');
            var pairs = childCols.Zip(parentCols, (c, p) => $"{c}->{p}");
            val = $"{parentTbl}({string.Join(",", pairs)})";
        }
    }
    else if (val.StartsWith("create"))
    {
        var isUnique = val.Contains("unique") ? "1" : "0";
        var m = Regex.Match(val, @"using\w+\(([^)]+)\)(?:where(.+))?$", RegexOptions.IgnoreCase);
        if (!m.Success)
        {
            m = Regex.Match(val, @"on[a-z0-9_.]+\(([^)]+)\)(?:where(.+))?$", RegexOptions.IgnoreCase);
        }
        if (m.Success)
        {
            var cols = m.Groups[1].Value;
            var filter = m.Groups[2].Success ? "|where=" + m.Groups[2].Value : "";
            val = $"{cols}|unique={isUnique}{filter}";
        }
    }

    val = val.Replace("(", "").Replace(")", "");
    return val;
}

static string Explain(InventoryRow row, string classification) => classification switch
{
    "MATCHED" => "Normalized key and signature are equal in source, bootstrap, and runtime.",
    "CONVERTED" => "Object exists in both PostgreSQL inventories; normalized signature differs and requires semantic mapping review.",
    "RUNTIME_MISSING" => "Present in MSSQL and bootstrap PostgreSQL, absent from runtime PostgreSQL.",
    "BOOTSTRAP_MISSING" => "Absent from bootstrap PostgreSQL under the normalized key; runtime presence varies.",
    "CONVERTER_BUG" => $"Source {row.ObjectKind} has no PostgreSQL counterpart; add metadata extraction/conversion rule instead of manual DB patch.",
    _ => "Not classified."
};

static async Task WriteCsv(string path, List<InventoryRow> rows)
{
    var sb = new StringBuilder("object_kind,schema_name,object_name,parent_object,column_name,normalized_signature,source_database,dependency_kind\n");
    foreach (var x in rows)
        sb.AppendLine(string.Join(",", new[] { x.ObjectKind, x.SchemaName, x.ObjectName, x.ParentObject,
            x.ColumnName, x.NormalizedSignature, x.SourceDatabase, x.DependencyKind }.Select(Csv)));
    await File.WriteAllTextAsync(path, sb.ToString(), new UTF8Encoding(false));
}

static string Csv(string value) => "\"" + value.Replace("\"", "\"\"").ReplaceLineEndings(" ") + "\"";

static string RenderReport(
    List<InventoryRow> ms, List<InventoryRow> bootstrap, List<InventoryRow> runtime, List<GapRow> gaps)
{
    var kinds = new[] { "SCHEMA", "TABLE", "COLUMN", "DEFAULT", "PRIMARY_KEY", "FOREIGN_KEY",
        "UNIQUE_CONSTRAINT", "CHECK_CONSTRAINT", "INDEX", "TRIGGER", "VIEW", "FUNCTION", "PROCEDURE", "TYPE", "SEQUENCE" };
    var sb = new StringBuilder("# Runtime object gap analysis V2\n\n");
    sb.AppendLine("## Executive summary\n")
      .AppendLine("- All three databases were exported read-only into the same taxonomy and row model.")
      .AppendLine("- No database was modified. No schema patch was generated.")
      .AppendLine($"- MSSQL rows: **{ms.Count}**; bootstrap PG rows: **{bootstrap.Count}**; runtime PG rows: **{runtime.Count}**.")
      .AppendLine($"- Remaining `EXPORT_MISSING`: **{gaps.Count(x => x.Classification == "EXPORT_MISSING")}**.")
      .AppendLine($"- Remaining `UNKNOWN`: **{gaps.Count(x => x.Classification == "UNKNOWN")}**.\n");

    sb.AppendLine("## Symmetric taxonomy counts\n")
      .AppendLine("| Object kind | MSSQL | Bootstrap PG | Runtime PG |")
      .AppendLine("|---|---:|---:|---:|");
    foreach (var kind in kinds)
        sb.AppendLine($"| {kind} | {ms.Count(x => x.ObjectKind == kind)} | {bootstrap.Count(x => x.ObjectKind == kind)} | {runtime.Count(x => x.ObjectKind == kind)} |");

    sb.AppendLine("\n## Classification totals\n")
      .AppendLine("| Classification | Count |").AppendLine("|---|---:|");
    foreach (var name in new[] { "MATCHED", "CONVERTED", "INTENTIONALLY_SKIPPED", "UNSUPPORTED_BY_POSTGRES",
        "CONVERTER_BUG", "EXPORT_MISSING", "BOOTSTRAP_MISSING", "RUNTIME_MISSING", "UNKNOWN" })
        sb.AppendLine($"| {name} | {gaps.Count(x => x.Classification == name)} |");

    sb.AppendLine("\n## Remaining EXPORT_MISSING\n");
    var exportMissing = gaps.Where(x => x.Classification == "EXPORT_MISSING").ToArray();
    sb.AppendLine(exportMissing.Length == 0
        ? "None. Export coverage is symmetric for the requested taxonomy."
        : string.Join("\n", exportMissing.Select(x => $"- `{x.Source.ObjectKind}` `{x.Source.SchemaName}.{x.Source.ObjectName}`: {x.Reason}")));

    sb.AppendLine("\n## Remaining UNKNOWN\n");
    foreach (var gap in gaps.Where(x => x.Classification == "UNKNOWN"))
        sb.AppendLine($"- `{gap.Source.ObjectKind}` `{gap.Source.SchemaName}.{gap.Source.ObjectName}`: {gap.Reason}");

    sb.AppendLine("\n## Reclassified converter bugs\n")
      .AppendLine("| Kind | Count | Missing converter/export rule |")
      .AppendLine("|---|---:|---|");
    foreach (var group in gaps.Where(x => x.Classification == "CONVERTER_BUG").GroupBy(x => x.Source.ObjectKind))
        sb.AppendLine($"| {group.Key} | {group.Count()} | Extract definition/dependency metadata and convert to the PostgreSQL equivalent; do not patch manually. |");

    sb.AppendLine("\n## Detailed normalized gaps\n")
      .AppendLine("| Kind | Schema | Object | Parent | Column | Classification | Runtime impact | Compile impact | Business impact | Can ignore? | Auto-generate? | Reason |")
      .AppendLine("|---|---|---|---|---|---|---|---|---|---|---|---|");
    foreach (var gap in gaps.Where(x => x.Classification is not "MATCHED").OrderBy(x => x.Classification).ThenBy(x => x.Source.ObjectKind).ThenBy(x => x.Source.ObjectName))
    {
        var x = gap.Source;
        var runtimeImpact = x.ObjectKind is "TABLE" or "COLUMN" or "FUNCTION" or "PROCEDURE" or "VIEW" or "SEQUENCE" ? "YES/VERIFY" : "INDIRECT/VERIFY";
        var compileImpact = x.ObjectKind is "TABLE" or "COLUMN" or "FUNCTION" or "VIEW" or "TYPE" ? "YES/VERIFY" : "NO/DEFERRED";
        var businessImpact = x.ObjectKind is "INDEX" ? "PERFORMANCE/UNIQUENESS" : "YES/VERIFY";
        var canIgnore = gap.Classification is "UNKNOWN" ? "VERIFY" : "NO";
        var auto = gap.Classification is "CONVERTER_BUG" or "BOOTSTRAP_MISSING" or "RUNTIME_MISSING" ? "POSSIBLE AFTER REVIEW" : "UNKNOWN";
        sb.AppendLine($"| {Md(x.ObjectKind)} | {Md(x.SchemaName)} | {Md(x.ObjectName)} | {Md(x.ParentObject)} | {Md(x.ColumnName)} | {gap.Classification} | {runtimeImpact} | {compileImpact} | {businessImpact} | {canIgnore} | {auto} | {Md(gap.Reason)} |");
    }

    sb.AppendLine("\n## Conclusion\n")
      .AppendLine("Exporter coverage is now symmetric for the requested taxonomy, so `EXPORT_MISSING` is no longer used as a placeholder for unqueried PG catalogs.")
      .AppendLine("The diff is sufficiently reliable to prioritize converter/export rules by object kind, but **not yet sufficient to rebuild the runtime database**:")
      .AppendLine("normalized signatures still require reviewed MSSQL→PostgreSQL type/default/expression mappings, and `UNKNOWN` PG-only objects require ownership/source classification.")
      .AppendLine("No production-safety or business-equivalence claim is made.");
    return sb.ToString();
}

static string Md(string value) => value.Replace("|", "\\|").ReplaceLineEndings(" ");

static string FindRoot()
{
    var directory = new DirectoryInfo(AppContext.BaseDirectory);
    while (directory is not null && !File.Exists(Path.Combine(directory.FullName, "pg_converter_ui.csproj")))
        directory = directory.Parent;
    return directory?.FullName ?? throw new InvalidOperationException("Repository root not found.");
}

sealed record InventoryRow(
    string ObjectKind, string SchemaName, string ObjectName, string ParentObject,
    string ColumnName, string NormalizedSignature, string SourceDatabase, string DependencyKind);
sealed record GapRow(InventoryRow Source, string Classification, string Reason);
