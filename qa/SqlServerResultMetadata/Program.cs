using System.Data;
using System.Data.Common;
using System.Text.Json;
using Microsoft.Data.SqlClient;
using pg_converter_ui;

var options = Options.Parse(args);
if (options.ShowHelp)
{
    Options.PrintHelp();
    return 0;
}

var connectionString = Environment.GetEnvironmentVariable("MSSQL_SOURCE_CONNECTION");
if (string.IsNullOrWhiteSpace(connectionString))
{
    Console.Error.WriteLine("Set MSSQL_SOURCE_CONNECTION. Credentials must not be passed as arguments or stored in files.");
    return 2;
}

var repositoryRoot = FindRepositoryRoot();
var blockedPath = Path.GetFullPath(options.BlockedPath ?? Path.Combine(
    repositoryRoot, "reports", "runtime_validation_results.json"));
var outputPath = Path.GetFullPath(options.OutputPath ?? Path.Combine(
    repositoryRoot, "reports", "generated", "sqlserver_result_metadata.json"));

var routineNames = options.RoutineNames.Count > 0
    ? options.RoutineNames
    : ReadBlockedRoutineNames(blockedPath);
if (routineNames.Count == 0)
{
    Console.Error.WriteLine("No routines selected. Pass --routines or provide a runtime result file containing BLOCKED routines.");
    return 3;
}

var results = new List<SqlServerRoutineResultMetadata>();
await using var connection = new SqlConnection(connectionString);
await connection.OpenAsync();
foreach (var requestedName in routineNames.Distinct(StringComparer.OrdinalIgnoreCase).Order())
{
    var routine = await FindRoutine(connection, requestedName, options.DefaultSchema);
    if (routine is null)
    {
        results.Add(new(requestedName, null, null, null, "NotFound",
            "No matching SQL Server procedure or function was found.", []));
        Console.WriteLine($"NotFound {requestedName}");
        continue;
    }

    SqlServerRoutineResultMetadata metadata;
    if (routine.Type is "IF" or "TF")
        metadata = await DescribeTableValuedFunction(connection, requestedName, routine);
    else if (routine.Type is "P" or "PC")
        metadata = await DescribeProcedure(connection, requestedName, routine);
    else
        metadata = new(requestedName, routine.Schema, routine.Name, routine.TypeDescription,
            "NoResultSet", "Scalar functions do not expose a tabular first result set.", []);

    results.Add(metadata);
    Console.WriteLine($"{metadata.Status,-11} {requestedName} ({metadata.Columns.Count} column(s))");
}

var export = new SqlServerResultMetadataExport(
    SqlServerResultMetadataFile.CurrentSchemaVersion,
    DateTimeOffset.UtcNow,
    results);
Directory.CreateDirectory(Path.GetDirectoryName(outputPath)!);
await File.WriteAllTextAsync(outputPath, SqlServerResultMetadataFile.Serialize(export));
Console.WriteLine($"Wrote {results.Count} routine result(s) to {outputPath}");
return results.Any(r => r.Status == "Error") ? 1 : 0;

static async Task<RoutineInfo?> FindRoutine(SqlConnection connection, string requestedName, string defaultSchema)
{
    var parts = requestedName.Split('.', 2, StringSplitOptions.TrimEntries);
    var schema = parts.Length == 2 ? parts[0] : defaultSchema;
    var name = parts.Length == 2 ? parts[1] : requestedName;
    await using var command = connection.CreateCommand();
    command.CommandText = """
        SELECT TOP (1) o.object_id, s.name, o.name, o.type, o.type_desc
        FROM sys.objects o
        JOIN sys.schemas s ON s.schema_id = o.schema_id
        WHERE s.name = @schema
          AND o.name = @name
          AND o.type IN ('P', 'PC', 'IF', 'TF', 'FN', 'FS')
        ORDER BY CASE o.type WHEN 'P' THEN 0 WHEN 'PC' THEN 1 ELSE 2 END;
        """;
    command.Parameters.Add(new SqlParameter("@schema", SqlDbType.NVarChar, 128) { Value = schema });
    command.Parameters.Add(new SqlParameter("@name", SqlDbType.NVarChar, 128) { Value = name });
    await using var reader = await command.ExecuteReaderAsync();
    return await reader.ReadAsync()
        ? new(reader.GetInt32(0), reader.GetString(1), reader.GetString(2),
            reader.GetString(3).Trim(), reader.GetString(4))
        : null;
}

static async Task<SqlServerRoutineResultMetadata> DescribeProcedure(
    SqlConnection connection, string requestedName, RoutineInfo routine)
{
    // Tier 1: sys.dm_exec_describe_first_result_set_for_object (SQL Server 2012+).
    var dmvAttempt = await DescribeWithDescribeFirstResultSetForObject(connection, requestedName, routine);
    if (dmvAttempt.Status != "Error")
        return dmvAttempt;

    // Tier 2: sys.sp_describe_first_result_set (SQL Server 2012+).
    var spAttempt = await DescribeWithStoredProcedure(connection, routine);
    if (spAttempt.Status != "Error")
        return spAttempt with { RequestedName = requestedName };

    // Tier 3: SET FMTONLY ON (SQL Server 2008+). Wrapped in a transaction that is
    // always rolled back, since FMTONLY is documented to sometimes still execute
    // statements it does not recognize (e.g. inside dynamic SQL or before a temp
    // table it depends on has been created).
    var fmtOnlyAttempt = await DescribeWithFmtOnly(connection, requestedName, routine);
    if (fmtOnlyAttempt.Status != "Error")
        return fmtOnlyAttempt;

    return dmvAttempt with
    {
        ErrorReason = $"{dmvAttempt.ErrorReason} | sp_describe_first_result_set: {spAttempt.ErrorReason} | FMTONLY: {fmtOnlyAttempt.ErrorReason}"
    };
}

static async Task<SqlServerRoutineResultMetadata> DescribeWithDescribeFirstResultSetForObject(
    SqlConnection connection, string requestedName, RoutineInfo routine)
{
    try
    {
        await using var command = connection.CreateCommand();
        command.CommandText = """
            SELECT column_ordinal, name, system_type_name, is_nullable,
                   error_number, error_message, error_type_desc
            FROM sys.dm_exec_describe_first_result_set_for_object(@object_id, 0)
            ORDER BY column_ordinal;
            """;
        command.Parameters.Add(new SqlParameter("@object_id", SqlDbType.Int) { Value = routine.ObjectId });
        await using var reader = await command.ExecuteReaderAsync();
        var columns = new List<SqlServerResultColumnMetadata>();
        string? error = null;
        while (await reader.ReadAsync())
        {
            if (!reader.IsDBNull(4))
            {
                error = $"{reader.GetValue(6)} {reader.GetValue(4)}: {reader.GetValue(5)}";
                continue;
            }
            if (reader.IsDBNull(0) || reader.IsDBNull(2))
                continue;
            var sqlType = reader.GetString(2);
            columns.Add(new(reader.GetInt32(0),
                reader.IsDBNull(1) ? null : reader.GetString(1),
                sqlType,
                reader.IsDBNull(3) ? null : reader.GetBoolean(3),
                SqlServerResultTypeMapper.TryMapToPostgreSql(sqlType)));
        }

        if (error != null)
            return new(requestedName, routine.Schema, routine.Name, routine.TypeDescription,
                "Error", error, columns);
        return new(requestedName, routine.Schema, routine.Name, routine.TypeDescription,
            columns.Count > 0 ? "Success" : "NoResultSet",
            columns.Count > 0 ? null : "SQL Server reported no first result-set columns.", columns);
    }
    catch (SqlException ex)
    {
        return new(requestedName, routine.Schema, routine.Name, routine.TypeDescription,
            "Error", $"dm_exec_describe_first_result_set_for_object {ex.Number}: {ex.Message}", []);
    }
}

static async Task<SqlServerRoutineResultMetadata> DescribeWithStoredProcedure(
    SqlConnection connection, RoutineInfo routine)
{
    var batch = $"EXEC {Quote(routine.Schema)}.{Quote(routine.Name)}";
    try
    {
        await using var command = connection.CreateCommand();
        command.CommandText = "sys.sp_describe_first_result_set";
        command.CommandType = CommandType.StoredProcedure;
        command.Parameters.Add(new SqlParameter("@tsql", SqlDbType.NVarChar, -1) { Value = batch });
        command.Parameters.Add(new SqlParameter("@params", SqlDbType.NVarChar, -1) { Value = DBNull.Value });
        command.Parameters.Add(new SqlParameter("@browse_information_mode", SqlDbType.TinyInt) { Value = 0 });
        await using var reader = await command.ExecuteReaderAsync();
        var columns = new List<SqlServerResultColumnMetadata>();
        while (await reader.ReadAsync())
        {
            var ordinal = reader.GetOrdinal("column_ordinal");
            var name = reader.GetOrdinal("name");
            var type = reader.GetOrdinal("system_type_name");
            var nullable = reader.GetOrdinal("is_nullable");
            if (reader.IsDBNull(type)) continue;
            var sqlType = reader.GetString(type);
            columns.Add(new(reader.GetInt32(ordinal),
                reader.IsDBNull(name) ? null : reader.GetString(name),
                sqlType,
                reader.IsDBNull(nullable) ? null : reader.GetBoolean(nullable),
                SqlServerResultTypeMapper.TryMapToPostgreSql(sqlType)));
        }
        return new(routine.Name, routine.Schema, routine.Name, routine.TypeDescription,
            columns.Count > 0 ? "Success" : "NoResultSet",
            columns.Count > 0 ? null : "sp_describe_first_result_set reported no columns.", columns);
    }
    catch (SqlException ex)
    {
        return new(routine.Name, routine.Schema, routine.Name, routine.TypeDescription,
            "Error", $"sp_describe_first_result_set {ex.Number}: {ex.Message}", []);
    }
}

static async Task<SqlServerRoutineResultMetadata> DescribeWithFmtOnly(
    SqlConnection connection, string requestedName, RoutineInfo routine)
{
    var declaration = await BuildParameterDeclaration(connection, routine);
    if (declaration is null)
        return new(requestedName, routine.Schema, routine.Name, routine.TypeDescription,
            "Error", "Procedure has a table-valued, cursor, or unresolvable parameter type; FMTONLY probing skipped.", []);

    await using var transaction = (SqlTransaction)await connection.BeginTransactionAsync();
    try
    {
        await using var command = connection.CreateCommand();
        command.Transaction = transaction;
        command.CommandTimeout = 30;
        command.CommandText = $"""
            {declaration.Value.DeclareBlock}
            SET FMTONLY ON;
            EXEC {Quote(routine.Schema)}.{Quote(routine.Name)} {declaration.Value.ExecArgs};
            SET FMTONLY OFF;
            """;
        IReadOnlyList<DbColumn> resultColumns;
        await using (var reader = await command.ExecuteReaderAsync())
            resultColumns = reader.GetColumnSchema();
        await transaction.RollbackAsync();

        if (resultColumns.Count == 0)
            return new(requestedName, routine.Schema, routine.Name, routine.TypeDescription,
                "NoResultSet", "SET FMTONLY ON reported no first result-set columns.", []);

        var columns = new List<SqlServerResultColumnMetadata>();
        int ordinal = 1;
        foreach (var col in resultColumns)
        {
            var sqlType = BuildSystemTypeName(col);
            columns.Add(new(ordinal++,
                string.IsNullOrEmpty(col.ColumnName) ? null : col.ColumnName,
                sqlType,
                col.AllowDBNull,
                SqlServerResultTypeMapper.TryMapToPostgreSql(sqlType)));
        }
        return new(requestedName, routine.Schema, routine.Name, routine.TypeDescription,
            "Success", null, columns);
    }
    catch (SqlException ex)
    {
        try { await transaction.RollbackAsync(); } catch { /* connection may already be broken */ }
        return new(requestedName, routine.Schema, routine.Name, routine.TypeDescription,
            "Error", $"FMTONLY {ex.Number}: {ex.Message}", []);
    }
}

static string BuildSystemTypeName(DbColumn col)
{
    var baseName = (col.DataTypeName ?? "sql_variant").ToLowerInvariant();
    return baseName switch
    {
        "varchar" or "char" or "binary" or "varbinary" => col.ColumnSize is int size && size > 0
            ? $"{baseName}({(size == int.MaxValue ? "max" : size)})"
            : baseName,
        "nvarchar" or "nchar" => col.ColumnSize is int nsize && nsize > 0
            ? $"{baseName}({(nsize == int.MaxValue ? "max" : nsize)})"
            : baseName,
        "decimal" or "numeric" => col.NumericPrecision is int p
            ? $"{baseName}({p},{col.NumericScale ?? 0})"
            : baseName,
        _ => baseName
    };
}

static async Task<(string DeclareBlock, string ExecArgs)?> BuildParameterDeclaration(
    SqlConnection connection, RoutineInfo routine)
{
    await using var command = connection.CreateCommand();
    command.CommandText = """
        SELECT p.parameter_id, p.name, t.name AS type_name, p.max_length, p.precision, p.scale, p.is_readonly
        FROM sys.parameters p
        JOIN sys.types t ON t.user_type_id = p.user_type_id
        WHERE p.object_id = @object_id
        ORDER BY p.parameter_id;
        """;
    command.Parameters.Add(new SqlParameter("@object_id", SqlDbType.Int) { Value = routine.ObjectId });
    await using var reader = await command.ExecuteReaderAsync();
    var declares = new List<string>();
    var args = new List<string>();
    while (await reader.ReadAsync())
    {
        var parameterId = reader.GetInt32(0);
        if (parameterId == 0) continue; // return value slot
        var name = reader.GetString(1);
        var typeName = reader.GetString(2);
        var isReadonly = reader.GetBoolean(6);

        if (isReadonly || string.Equals(typeName, "cursor", StringComparison.OrdinalIgnoreCase))
            return null;

        var declType = BuildDeclareTypeName(typeName,
            reader.GetInt16(3), reader.GetByte(4), reader.GetByte(5));
        var varName = $"@__p{parameterId}";
        declares.Add($"DECLARE {varName} {declType} = NULL;");
        args.Add($"{name} = {varName}");
    }
    return (string.Join("\n", declares), string.Join(", ", args));
}

static string BuildDeclareTypeName(string typeName, short maxLength, byte precision, byte scale)
{
    var lower = typeName.ToLowerInvariant();
    return lower switch
    {
        "varchar" or "char" or "binary" or "varbinary" =>
            maxLength == -1 ? $"{lower}(max)" : $"{lower}({maxLength})",
        "nvarchar" or "nchar" =>
            maxLength == -1 ? $"{lower}(max)" : $"{lower}({maxLength / 2})",
        "decimal" or "numeric" => $"{lower}({precision},{scale})",
        _ => lower
    };
}

static async Task<SqlServerRoutineResultMetadata> DescribeTableValuedFunction(
    SqlConnection connection, string requestedName, RoutineInfo routine)
{
    await using var command = connection.CreateCommand();
    command.CommandText = """
        SELECT c.column_id, c.name,
               t.name +
                 CASE
                   WHEN t.name IN ('varchar','char','varbinary','binary','nvarchar','nchar')
                     THEN '(' + CASE WHEN c.max_length = -1 THEN 'max'
                         WHEN t.name IN ('nvarchar','nchar') THEN CONVERT(varchar(10), c.max_length / 2)
                         ELSE CONVERT(varchar(10), c.max_length) END + ')'
                   WHEN t.name IN ('decimal','numeric')
                     THEN '(' + CONVERT(varchar(10), c.precision) + ',' + CONVERT(varchar(10), c.scale) + ')'
                   ELSE ''
                 END AS system_type_name,
               c.is_nullable
        FROM sys.columns c
        JOIN sys.types t ON t.user_type_id = c.user_type_id
        WHERE c.object_id = @object_id
        ORDER BY c.column_id;
        """;
    command.Parameters.Add(new SqlParameter("@object_id", SqlDbType.Int) { Value = routine.ObjectId });
    await using var reader = await command.ExecuteReaderAsync();
    var columns = new List<SqlServerResultColumnMetadata>();
    while (await reader.ReadAsync())
    {
        var sqlType = reader.GetString(2);
        columns.Add(new(reader.GetInt32(0), reader.GetString(1), sqlType,
            reader.GetBoolean(3), SqlServerResultTypeMapper.TryMapToPostgreSql(sqlType)));
    }
    return new(requestedName, routine.Schema, routine.Name, routine.TypeDescription,
        columns.Count > 0 ? "Success" : "NoResultSet",
        columns.Count > 0 ? null : "The table-valued function has no catalog columns.", columns);
}

static List<string> ReadBlockedRoutineNames(string path)
{
    if (!File.Exists(path))
        throw new FileNotFoundException("Blocked runtime result file not found.", path);
    using var document = JsonDocument.Parse(File.ReadAllText(path));
    return document.RootElement.EnumerateArray()
        .Where(item =>
        {
            var status = item.GetProperty("Status");
            return status.ValueKind == JsonValueKind.Number
                ? status.GetInt32() == 2
                : status.GetString()?.Equals("Blocked", StringComparison.OrdinalIgnoreCase) == true;
        })
        .Where(item => item.TryGetProperty("RootCause", out var cause) &&
            cause.GetString()?.Contains("SETOF record", StringComparison.OrdinalIgnoreCase) == true)
        .Select(item => item.GetProperty("Name").GetString())
        .Where(name => !string.IsNullOrWhiteSpace(name))
        .Cast<string>()
        .ToList();
}

static string FindRepositoryRoot()
{
    var directory = new DirectoryInfo(AppContext.BaseDirectory);
    while (directory != null && !File.Exists(Path.Combine(directory.FullName, "pg_converter_ui.csproj")))
        directory = directory.Parent;
    return directory?.FullName ?? Directory.GetCurrentDirectory();
}

static string Quote(string identifier) => $"[{identifier.Replace("]", "]]")}]";

sealed record RoutineInfo(int ObjectId, string Schema, string Name, string Type, string TypeDescription);

sealed record Options(
    bool ShowHelp,
    string DefaultSchema,
    string? BlockedPath,
    string? OutputPath,
    List<string> RoutineNames)
{
    public static Options Parse(string[] args)
    {
        var help = false;
        var schema = "dbo";
        string? blocked = null;
        string? output = null;
        var routines = new List<string>();
        for (var i = 0; i < args.Length; i++)
        {
            switch (args[i])
            {
                case "-h" or "--help": help = true; break;
                case "--schema": schema = RequireValue(args, ref i); break;
                case "--blocked": blocked = RequireValue(args, ref i); break;
                case "--output": output = RequireValue(args, ref i); break;
                case "--routines":
                    routines.AddRange(RequireValue(args, ref i)
                        .Split(',', StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries));
                    break;
                default: throw new ArgumentException($"Unknown argument: {args[i]}");
            }
        }
        return new(help, schema, blocked, output, routines);
    }

    static string RequireValue(string[] args, ref int index)
    {
        if (++index >= args.Length) throw new ArgumentException($"Missing value for {args[index - 1]}");
        return args[index];
    }

    public static void PrintHelp() => Console.WriteLine("""
        SQL Server result metadata extractor

        Environment:
          MSSQL_SOURCE_CONNECTION   Required SQL Server connection string.

        Options:
          --routines name1,name2     Extract only the named routines.
          --blocked path             Read BLOCKED names from runtime validation JSON.
          --schema dbo               Default source schema for unqualified names.
          --output path              JSON output path.
          --help                     Show this help.
        """);
}
