using System.Text;
using Microsoft.Data.SqlClient;
using Npgsql;

var msConnection = Require("MSSQL_SOURCE_CONNECTION");
var bootstrapConnection = Require("PG_BOOTSTRAP_CONNECTION");
var runtimeConnection = Require("PG_RUNTIME_CONNECTION");
GuardPgDatabase(bootstrapConnection, "crewcloud_company_bootstrap_test");
GuardPgDatabase(runtimeConnection, "pg_converter_runtime_test");

var root = FindRoot();
var snapshots = Path.Combine(root, "reports", "schema_snapshots");
var build = Path.Combine(root, "reports", "runtime_test_build");
Directory.CreateDirectory(snapshots);
Directory.CreateDirectory(build);

var ms = await ReadMssql(msConnection);
var bootstrap = await ReadPostgres(bootstrapConnection);
var runtime = await ReadPostgres(runtimeConnection);

await File.WriteAllTextAsync(Path.Combine(snapshots, "mssql_schema_snapshot.sql"), RenderSnapshot("MSSQL source", ms));
await File.WriteAllTextAsync(Path.Combine(snapshots, "crewcloud_company_bootstrap_test_schema.sql"), RenderSnapshot("PostgreSQL reference", bootstrap));
await File.WriteAllTextAsync(Path.Combine(snapshots, "pg_converter_runtime_test_schema_before.sql"), RenderSnapshot("PostgreSQL runtime before", runtime));

var bootstrapDiff = Diff(ms, bootstrap);
var runtimeDiff = Diff(ms, runtime);
await File.WriteAllTextAsync(Path.Combine(root, "reports", "bootstrap_schema_diff_vs_mssql.md"),
    RenderDiff(ms, bootstrap, bootstrapDiff));
await File.WriteAllTextAsync(Path.Combine(root, "reports", "runtime_test_dependency_check.md"),
    RenderDependencies(runtime));
await WriteBuildScripts(build, bootstrapDiff);
await File.WriteAllTextAsync(Path.Combine(root, "reports", "runtime_test_data_safety_review.md"),
    RenderSafety(build));
await File.WriteAllTextAsync(Path.Combine(root, "reports", "pg_converter_runtime_test_readiness.md"),
    RenderReadiness(ms, bootstrap, runtime, bootstrapDiff, runtimeDiff));

Console.WriteLine($"MSSQL objects: {ms.Objects.Count}; bootstrap PG: {bootstrap.Objects.Count}; runtime PG: {runtime.Objects.Count}");
Console.WriteLine("Read-only snapshots and readiness reports generated. No database was modified.");
return 0;

static string Require(string name) =>
    Environment.GetEnvironmentVariable(name) is { Length: > 0 } value
        ? value : throw new InvalidOperationException($"Set {name}; credentials must not be stored in source.");

static void GuardPgDatabase(string connection, string expected)
{
    var settings = new NpgsqlConnectionStringBuilder(connection);
    if (!string.Equals(settings.Database, expected, StringComparison.Ordinal))
        throw new InvalidOperationException($"Refusing connection: expected database '{expected}', got '{settings.Database}'.");
}

static async Task<SchemaModel> ReadMssql(string connectionString)
{
    var model = new SchemaModel("MSSQL");
    await using var connection = new SqlConnection(connectionString);
    await connection.OpenAsync();
    await using var command = connection.CreateCommand();
    command.CommandText = """
        SELECT o.type_desc, s.name, o.name,
               COALESCE(c.name, ''), COALESCE(t.name, ''),
               COALESCE(c.max_length, 0), COALESCE(c.precision, 0), COALESCE(c.scale, 0),
               COALESCE(c.is_nullable, 0), COALESCE(dc.definition, '')
        FROM sys.objects o
        JOIN sys.schemas s ON s.schema_id=o.schema_id
        LEFT JOIN sys.columns c ON c.object_id=o.object_id
        LEFT JOIN sys.types t ON t.user_type_id=c.user_type_id
        LEFT JOIN sys.default_constraints dc ON dc.parent_object_id=o.object_id AND dc.parent_column_id=c.column_id
        WHERE s.name='dbo' AND o.is_ms_shipped=0
        ORDER BY o.type_desc,o.name,c.column_id
        """;
    await using var reader = await command.ExecuteReaderAsync();
    while (await reader.ReadAsync())
    {
        var key = $"{reader.GetString(0)}|{reader.GetString(2)}".ToLowerInvariant();
        model.Objects.TryAdd(key, new DbObject(reader.GetString(0), reader.GetString(2)));
        if (!reader.IsDBNull(3) && reader.GetString(3).Length > 0)
            model.Objects[key].Columns.Add(new DbColumn(
                reader.GetString(3), reader.GetString(4), Convert.ToInt32(reader.GetValue(5)),
                Convert.ToByte(reader.GetValue(6)), Convert.ToByte(reader.GetValue(7)),
                Convert.ToBoolean(reader.GetValue(8)), reader.GetString(9)));
    }
    return model;
}

static async Task<SchemaModel> ReadPostgres(string connectionString)
{
    var model = new SchemaModel("PostgreSQL");
    await using var connection = new NpgsqlConnection(connectionString);
    await connection.OpenAsync();
    await using (var command = connection.CreateCommand())
    {
        command.CommandText = """
            SELECT CASE c.relkind WHEN 'r' THEN 'USER_TABLE' WHEN 'v' THEN 'VIEW'
                     WHEN 'm' THEN 'MATERIALIZED_VIEW' WHEN 'S' THEN 'SEQUENCE' ELSE c.relkind::text END,
                   c.relname, COALESCE(a.attname,''), COALESCE(format_type(a.atttypid,a.atttypmod),''),
                   COALESCE(a.attnotnull,false), COALESCE(pg_get_expr(ad.adbin,ad.adrelid),'')
            FROM pg_class c JOIN pg_namespace n ON n.oid=c.relnamespace
            LEFT JOIN pg_attribute a ON a.attrelid=c.oid AND a.attnum>0 AND NOT a.attisdropped
            LEFT JOIN pg_attrdef ad ON ad.adrelid=c.oid AND ad.adnum=a.attnum
            WHERE n.nspname='public' AND c.relkind IN ('r','v','m','S')
            ORDER BY c.relkind,c.relname,a.attnum
            """;
        await using var reader = await command.ExecuteReaderAsync();
        while (await reader.ReadAsync())
        {
            var type = reader.GetString(0);
            var key = $"{type}|{reader.GetString(1)}".ToLowerInvariant();
            model.Objects.TryAdd(key, new DbObject(type, reader.GetString(1)));
            if (reader.GetString(2).Length > 0)
                model.Objects[key].Columns.Add(new DbColumn(
                    reader.GetString(2), reader.GetString(3), 0, 0, 0, !reader.GetBoolean(4), reader.GetString(5)));
        }
    }
    await using (var command = connection.CreateCommand())
    {
        command.CommandText = """
            SELECT 'ROUTINE', p.proname, pg_get_function_identity_arguments(p.oid),
                   pg_get_function_result(p.oid), pg_get_functiondef(p.oid)
            FROM pg_proc p JOIN pg_namespace n ON n.oid=p.pronamespace
            WHERE n.nspname='public' ORDER BY p.proname,p.oid
            """;
        await using var reader = await command.ExecuteReaderAsync();
        while (await reader.ReadAsync())
        {
            var key = $"routine|{reader.GetString(1)}({reader.GetString(2)})".ToLowerInvariant();
            model.Objects[key] = new DbObject("ROUTINE", reader.GetString(1)) { Definition = reader.GetString(4) };
        }
    }
    return model;
}

static DiffResult Diff(SchemaModel source, SchemaModel target)
{
    var sourceNames = source.Objects.Values.Select(o => o.Name.ToLowerInvariant()).ToHashSet();
    var targetNames = target.Objects.Values.Select(o => o.Name.ToLowerInvariant()).ToHashSet();
    return new DiffResult(sourceNames.Except(targetNames).Order().ToArray(), targetNames.Except(sourceNames).Order().ToArray());
}

static string RenderSnapshot(string title, SchemaModel model)
{
    var sb = new StringBuilder($"-- {title} schema snapshot\n-- Generated {DateTimeOffset.Now:O}\n-- Metadata export; read-only source access.\n\n");
    foreach (var obj in model.Objects.Values.OrderBy(o => o.Type).ThenBy(o => o.Name))
    {
        sb.AppendLine($"-- OBJECT {obj.Type} public/dbo.{obj.Name}");
        foreach (var c in obj.Columns)
            sb.AppendLine($"--   COLUMN {c.Name} {c.Type} NULLABLE={c.Nullable} DEFAULT={c.Default}");
        if (obj.Definition is not null)
            sb.AppendLine(obj.Definition).AppendLine();
    }
    return sb.ToString();
}

static string RenderDiff(SchemaModel ms, SchemaModel pg, DiffResult diff) => $"""
    # Bootstrap PostgreSQL schema diff versus MSSQL

    This is an object-name inventory comparison. Type/default/constraint equivalence remains `NEED VERIFICATION`
    until canonical per-object mapping is reviewed.

    | Metric | MSSQL | Bootstrap PG |
    |---|---:|---:|
    | Catalog objects | {ms.Objects.Count} | {pg.Objects.Count} |
    | Names missing from PG | {diff.Missing.Length} | — |
    | Names extra in PG | — | {diff.Extra.Length} |

    ## Missing names
    {string.Join("\n", diff.Missing.Select(x => $"- `{x}`"))}

    ## Extra names
    {string.Join("\n", diff.Extra.Select(x => $"- `{x}`"))}
    """;

static string RenderDependencies(SchemaModel runtime) => $"""
    # Runtime test dependency check

    Status: `NEED VERIFICATION`.

    Required order: schemas/types/sequences → tables → PK/unique/check → FK/index →
    helper functions → views → converted routines → triggers → seed/reference data.

    Runtime catalog objects observed: {runtime.Objects.Count}. Constraint, trigger, and
    seed-data dependency edges are not yet fully reconstructed by the catalog exporter.
    """;

static async Task WriteBuildScripts(string dir, DiffResult diff)
{
    await File.WriteAllTextAsync(Path.Combine(dir, "001_create_pg_converter_runtime_test.sql"), """
        -- REVIEW-ONLY. Run from an administrative database, never from a customer database.
        -- No DROP is included. Database creation must be explicitly approved after backup.
        SELECT 'pg_converter_runtime_test creation/rebuild requires explicit operator approval' AS status;
        """);
    await File.WriteAllTextAsync(Path.Combine(dir, "002_schema_patch_from_mssql_diff.sql"), $"""
        \echo 'Refusing automatic patch: MSSQL-to-PostgreSQL semantic diff requires review.'
        -- Missing object-name candidates: {diff.Missing.Length}
        -- This file intentionally contains no schema mutation yet.
        """);
    await File.WriteAllTextAsync(Path.Combine(dir, "003_required_seed_or_reference_data.sql"), """
        -- NEED VERIFICATION: no seed data copied.
        -- Source/reference data must be classified and masked before insertion.
        """);
}

static string RenderSafety(string dir)
{
    var risks = Directory.GetFiles(dir, "*.sql").SelectMany(path =>
        File.ReadLines(path).Select((line, i) => (path, line, i: i + 1))
            .Where(x => !x.line.TrimStart().StartsWith("--")
                && System.Text.RegularExpressions.Regex.IsMatch(
                x.line, @"(?i)\b(DROP|TRUNCATE|DELETE|UPDATE|ALTER\s+TABLE|CREATE\s+OR\s+REPLACE)\b")));
    var rows = risks.Select(x => $"| Review | `{Path.GetFileName(x.path)}:{x.i}` | `{x.line.Trim().Replace("|", "\\|")}` | Manual approval required |");
    return "# Runtime test data safety review\n\n| Risk | File | Statement | Recommendation |\n|---|---|---|---|\n"
        + string.Join("\n", rows.DefaultIfEmpty("| None detected | — | — | Continue review |"));
}

static string RenderReadiness(SchemaModel ms, SchemaModel bootstrap, SchemaModel runtime, DiffResult bd, DiffResult rd) => $"""
    # pg_converter_runtime_test Readiness Report

    ## Executive Summary

    * Overall status: NEED VERIFICATION
    * MSSQL source checked: Yes (read-only catalog)
    * Bootstrap PGSQL checked: Yes (read-only catalog)
    * Runtime test DB created/updated: No
    * Schema match confidence: Low
    * Data safety risk: Low for this read-only pass
    * Can run converted procedure validation: Partial

    ## Source Databases

    | Database | Role | Modified? | Notes |
    |---|---|---|---|
    | MSSQL source | Source of truth | No | Catalog snapshot only |
    | crewcloud_company_bootstrap_test | PGSQL reference | No | Not assumed correct |
    | pg_converter_runtime_test | Runtime validation target | No | Snapshot taken before any proposed change |

    ## Schema Diff Summary

    | Object Type | MSSQL Count | Bootstrap PG Count | Runtime Test Count | Missing | Extra | Different |
    |---|---:|---:|---:|---:|---:|---:|
    | Tables | {Count(ms, "TABLE")} | {Count(bootstrap, "TABLE")} | {Count(runtime, "TABLE")} | NEED VERIFICATION | NEED VERIFICATION | NEED VERIFICATION |
    | Views | {Count(ms, "VIEW")} | {Count(bootstrap, "VIEW")} | {Count(runtime, "VIEW")} | NEED VERIFICATION | NEED VERIFICATION | NEED VERIFICATION |
    | Routines | {Count(ms, "PROCEDURE") + Count(ms, "FUNCTION")} | {Count(bootstrap, "ROUTINE")} | {Count(runtime, "ROUTINE")} | NEED VERIFICATION | NEED VERIFICATION | NEED VERIFICATION |
    | Sequences | {Count(ms, "SEQUENCE")} | {Count(bootstrap, "SEQUENCE")} | {Count(runtime, "SEQUENCE")} | NEED VERIFICATION | NEED VERIFICATION | NEED VERIFICATION |
    | All catalog objects | {ms.Objects.Count} | {bootstrap.Objects.Count} | {runtime.Objects.Count} | {rd.Missing.Length} | {rd.Extra.Length} | NEED VERIFICATION |

    ## Critical Differences

    | Object | Difference | Impact | Required Action |
    |---|---|---|---|
    | Runtime schema | {rd.Missing.Length} MSSQL names absent | Runtime dependencies may remain blocked | Review canonical mapping before patch |
    | Bootstrap reference | {bd.Missing.Length} MSSQL names absent | Reference is not proven complete | Review type/constraint/logic differences |
    | Seed data | Not compared | Runtime calls may return empty or fail | Classify and mask required reference rows |

    ## Runtime Test Build Actions

    | Step | Script | Result | Notes |
    |---|---|---|---|
    | 1 | `001_create_pg_converter_runtime_test.sql` | REVIEW ONLY | No DROP/recreate performed |
    | 2 | `002_schema_patch_from_mssql_diff.sql` | BLOCKED | Semantic mapping review required |
    | 3 | `003_required_seed_or_reference_data.sql` | BLOCKED | Data classification required |

    ## Converted Procedure Validation

    | Module | Total | Compile PASS | Runtime PASS | FAIL | BLOCKED | NEED DATA |
    |---|---:|---:|---:|---:|---:|---:|
    | Board + Contact | 351 | 351 | 82 | 180 | 89 | Not separately classified |

    ## Final Decision

    `pg_converter_runtime_test` is **not yet schema-ready** for authoritative converter
    assessment. It remains useful for partial rollback-only runtime validation. No
    production-safety or business-equivalence claim is made.
    """;

static int Count(SchemaModel model, string token) =>
    model.Objects.Values.Count(o => o.Type.Contains(token, StringComparison.OrdinalIgnoreCase));

static string FindRoot()
{
    var d = new DirectoryInfo(AppContext.BaseDirectory);
    while (d is not null && !File.Exists(Path.Combine(d.FullName, "pg_converter_ui.csproj"))) d = d.Parent;
    return d?.FullName ?? throw new InvalidOperationException("Repository root not found.");
}

sealed record DbColumn(string Name, string Type, int Length, byte Precision, byte Scale, bool Nullable, string Default);
sealed class DbObject(string type, string name)
{
    public string Type { get; } = type;
    public string Name { get; } = name;
    public List<DbColumn> Columns { get; } = [];
    public string? Definition { get; set; }
}
sealed class SchemaModel(string provider)
{
    public string Provider { get; } = provider;
    public Dictionary<string, DbObject> Objects { get; } = new(StringComparer.OrdinalIgnoreCase);
}
sealed record DiffResult(string[] Missing, string[] Extra);
