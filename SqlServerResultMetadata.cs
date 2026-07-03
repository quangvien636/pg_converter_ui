using System.Text.Json;
using System.Text.Json.Serialization;
using System.Text.RegularExpressions;

namespace pg_converter_ui;

public sealed record SqlServerResultMetadataExport(
    int SchemaVersion,
    DateTimeOffset GeneratedAtUtc,
    IReadOnlyList<SqlServerRoutineResultMetadata> Routines);

public sealed record SqlServerRoutineResultMetadata(
    string RequestedName,
    string? SchemaName,
    string? RoutineName,
    string? ObjectType,
    string Status,
    string? ErrorReason,
    IReadOnlyList<SqlServerResultColumnMetadata> Columns);

public sealed record SqlServerResultColumnMetadata(
    int Ordinal,
    string? Name,
    string SqlServerType,
    bool? IsNullable,
    string? PostgreSqlType);

public static class SqlServerResultMetadataFile
{
    public const int CurrentSchemaVersion = 1;

    static readonly JsonSerializerOptions Options = new()
    {
        PropertyNamingPolicy = JsonNamingPolicy.CamelCase,
        WriteIndented = true,
        DefaultIgnoreCondition = JsonIgnoreCondition.WhenWritingNull
    };

    public static string Serialize(SqlServerResultMetadataExport metadata) =>
        JsonSerializer.Serialize(metadata, Options);

    public static SqlServerResultMetadataExport Deserialize(string json)
    {
        var metadata = JsonSerializer.Deserialize<SqlServerResultMetadataExport>(json, Options)
            ?? throw new InvalidDataException("Result metadata JSON is empty.");
        if (metadata.SchemaVersion != CurrentSchemaVersion)
            throw new InvalidDataException(
                $"Unsupported result metadata schema version {metadata.SchemaVersion}; expected {CurrentSchemaVersion}.");
        return metadata;
    }
}

public static class ResultMetadataCatalog
{
    public static Dictionary<string, SqlServerRoutineResultMetadata> BuildLookup(
        IEnumerable<SqlServerRoutineResultMetadata> routines) =>
        routines
            .Where(r => r.Status.Equals("Success", StringComparison.OrdinalIgnoreCase) && r.Columns.Count > 0)
            .GroupBy(r => (r.RoutineName ?? r.RequestedName).ToLowerInvariant())
            .ToDictionary(g => g.Key, g => g.First(), StringComparer.OrdinalIgnoreCase);

    public static Dictionary<string, SqlServerRoutineResultMetadata>? TryLoadFromFile(string path)
    {
        if (!File.Exists(path))
            return null;
        var export = SqlServerResultMetadataFile.Deserialize(File.ReadAllText(path));
        return BuildLookup(export.Routines);
    }

    public static Dictionary<string, SqlServerRoutineResultMetadata>? TryLoadDefault()
    {
        var directory = new DirectoryInfo(AppContext.BaseDirectory);
        while (directory != null && !File.Exists(Path.Combine(directory.FullName, "pg_converter_ui.csproj")))
            directory = directory.Parent;
        if (directory == null)
            return null;
        var path = Path.Combine(directory.FullName, "reports", "generated", "sqlserver_result_metadata.json");
        return TryLoadFromFile(path);
    }
}

public static class SqlServerResultTypeMapper
{
    public static string? TryMapToPostgreSql(string sqlServerType)
    {
        if (string.IsNullOrWhiteSpace(sqlServerType))
            return null;

        var normalized = Regex.Replace(sqlServerType.Trim().ToLowerInvariant(), @"\s+", " ");
        var baseType = Regex.Replace(normalized, @"\s*\(.*\)$", "");
        var arguments = Regex.Match(normalized, @"\((.*)\)$").Groups[1].Value;

        return baseType switch
        {
            "tinyint" or "smallint" => "smallint",
            "int" or "integer" => "integer",
            "bigint" => "bigint",
            "bit" => "boolean",
            "real" => "real",
            "float" => "double precision",
            "decimal" or "numeric" => arguments.Length > 0 ? $"numeric({arguments})" : "numeric",
            "money" or "smallmoney" => "numeric(19,4)",
            "date" => "date",
            "time" => "time without time zone",
            "datetime" or "datetime2" or "smalldatetime" => "timestamp without time zone",
            "datetimeoffset" => "timestamp with time zone",
            "uniqueidentifier" => "uuid",
            "xml" => "xml",
            "binary" or "varbinary" or "image" => "bytea",
            "text" or "ntext" => "text",
            "varchar" or "nvarchar" when arguments.Equals("max", StringComparison.OrdinalIgnoreCase) => "text",
            "varchar" or "nvarchar" when arguments.Length > 0 => $"character varying({arguments})",
            "varchar" or "nvarchar" => "character varying",
            "char" or "nchar" when arguments.Length > 0 => $"character({arguments})",
            "char" or "nchar" => "character",
            "sysname" => "character varying(128)",
            _ => null
        };
    }
}
