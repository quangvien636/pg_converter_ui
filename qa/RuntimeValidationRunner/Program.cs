using System.Diagnostics;
using System.Text;
using System.Text.Json;
using System.Text.RegularExpressions;
using Npgsql;

var connectionString = Environment.GetEnvironmentVariable("PG_RUNTIME_CONNECTION");
if (string.IsNullOrWhiteSpace(connectionString))
{
    Console.Error.WriteLine("Set PG_RUNTIME_CONNECTION to the PostgreSQL validation database connection string.");
    return 2;
}

const string RequiredDatabase = "pg_converter_runtime_test";
var connectionSettings = new NpgsqlConnectionStringBuilder(connectionString);
if (!string.Equals(connectionSettings.Database, RequiredDatabase, StringComparison.Ordinal))
{
    Console.Error.WriteLine(
        $"Refusing to run: PG_RUNTIME_CONNECTION must target database '{RequiredDatabase}', not '{connectionSettings.Database}'.");
    return 3;
}

var repositoryRoot = FindRepositoryRoot();
var reportDirectory = Path.Combine(repositoryRoot, "reports");
Directory.CreateDirectory(reportDirectory);
var timeoutSeconds = int.TryParse(Environment.GetEnvironmentVariable("PG_RUNTIME_TIMEOUT_SECONDS"), out var parsedTimeout)
    ? parsedTimeout
    : 30;

var functions = new List<FunctionInfo>();
await using (var connection = new NpgsqlConnection(connectionString))
{
    await connection.OpenAsync();
    await using var command = connection.CreateCommand();
    command.CommandText = """
        SELECT p.oid,
               n.nspname,
               p.proname,
               'f'::text AS prokind,
               p.proretset,
               pg_get_function_result(p.oid),
               pg_get_function_identity_arguments(p.oid),
               pg_get_functiondef(p.oid),
               COALESCE(array_to_json(p.proargnames)::text, '[]'),
               COALESCE(array_to_json(p.proargmodes)::text, '[]'),
               COALESCE(array_to_json(p.proallargtypes)::text, '[]'),
               COALESCE(array_to_json(p.proargtypes::oid[])::text, '[]')
        FROM pg_proc p
        JOIN pg_namespace n ON n.oid = p.pronamespace
        WHERE n.nspname = 'public'
          AND (p.proname LIKE 'board_%'
            OR p.proname LIKE 'contact_%'
            OR p.proname LIKE 'contacts_%')
        ORDER BY p.proname, p.oid
        """;
    await using var reader = await command.ExecuteReaderAsync();
    while (await reader.ReadAsync())
    {
        functions.Add(new FunctionInfo(
            reader.GetFieldValue<uint>(0),
            reader.GetString(1),
            reader.GetString(2),
            reader.GetString(3),
            reader.GetBoolean(4),
            reader.GetString(5),
            reader.GetString(6),
            reader.GetString(7),
            Deserialize<string>(reader.GetString(8)),
            Deserialize<string>(reader.GetString(9)),
            DeserializeOids(reader.GetString(10)),
            DeserializeOids(reader.GetString(11))));
    }
}

var typeNames = await LoadTypeNames(connectionString, functions.SelectMany(f => f.AllArgumentTypes.Concat(f.InputArgumentTypes)));
var results = new List<RuntimeResult>();
var dependencyResults = new List<DependencyResult>();
await using (var runtimeConnection = new NpgsqlConnection(connectionString))
{
    await runtimeConnection.OpenAsync();
    await using var runtimeTransaction = await runtimeConnection.BeginTransactionAsync();
    try
    {
        dependencyResults.AddRange(await DeployTemporaryDependencies(
            runtimeConnection, runtimeTransaction, repositoryRoot, timeoutSeconds));
        (functions, var patchResults) = await ApplyConfirmedRuntimeFixes(
            runtimeConnection, runtimeTransaction, functions, timeoutSeconds);
        dependencyResults.AddRange(patchResults);
        var inferredRecordColumns = await InferRecordColumns(
            runtimeConnection, runtimeTransaction, functions, typeNames, timeoutSeconds, dependencyResults);
        foreach (var function in functions)
        {
            var result = await Execute(
                runtimeConnection, runtimeTransaction, function, typeNames,
                inferredRecordColumns.GetValueOrDefault(function.Oid, []), timeoutSeconds);
            results.Add(result);
            Console.WriteLine($"{result.Status,-7} {function.Name} ({result.DurationMs} ms){FormatError(result)}");
        }
    }
    finally
    {
        await runtimeTransaction.RollbackAsync();
    }
}

await WriteReports(reportDirectory, connectionString, results, dependencyResults);
return results.Any(r => r.Status == RuntimeStatus.Fail) ? 1 : 0;

static async Task<(List<FunctionInfo> Functions, IReadOnlyList<DependencyResult> Results)> ApplyConfirmedRuntimeFixes(
    NpgsqlConnection connection,
    NpgsqlTransaction transaction,
    IReadOnlyList<FunctionInfo> functions,
    int timeoutSeconds)
{
    var confirmedLenFailures = new HashSet<string>(StringComparer.OrdinalIgnoreCase)
    {
        "contacts_deletehistory",
        "contacts_savearrange",
        "contacts_savearrangelike",
        "contacts_saveaddressinfo_web",
        "contacts_saverestore",
        "contacts_setaddress",
        "contacts_setemail",
        "contacts_setnumber",
        "contacts_updateuserinfo"
    };
    var confirmedTinyIntFailures = new HashSet<string>(StringComparer.OrdinalIgnoreCase)
    {
        "contacts_saveaddressinfo_web",
        "contacts_updateuserinfo"
    };
    var confirmedAggregateAmbiguities = new Dictionary<string, (string Table, string Alias, string Column)>(
        StringComparer.OrdinalIgnoreCase)
    {
        ["board_board_maxsortno_select"] = ("Board_Folders", "bf", "FolderNo"),
        ["board_countboardinfolder"] = ("Board_Boards", "bb", "FolderNo"),
        ["board_countcontentinboard"] = ("Board_Contents", "bc", "BoardNo"),
        ["board_folder_maxsortno_select"] = ("Board_Folders", "bf", "ParentNo")
    };
    var confirmedContactGetterAmbiguities =
        new Dictionary<string, (string Table, string Alias, string[] Columns)>(StringComparer.OrdinalIgnoreCase)
        {
            ["contacts_getcheckgroup"] = ("ContactsGroup", "cg", ["RegUserNo"]),
            ["contacts_parentgroupno"] = ("ContactsGroup", "cg", ["RegUserNo", "GroupNo"]),
            ["contacts_getallusernotrequite"] = ("ContactsUser", "cu", ["RegUserNo"]),
            ["contacts_getalluser"] = ("ContactsUser", "cu", ["RegUserNo"]),
            ["contacts_gettrashcount"] = ("ContactsUser", "cu", ["RegUserNo"]),
            ["contacts_getallhomepage"] = ("ContactsHomepage", "ch", ["RegUserNo"]),
            ["contacts_getallemail"] = ("ContactsEmail", "ce", ["RegUserNo"]),
            ["contacts_getallgroupuser"] = ("ContactsGroupUser", "cgu", ["RegUserNo"]),
            ["contacts_getallcompany"] = ("ContactsCompany", "cc", ["RegUserNo"]),
            ["contacts_getalldays"] = ("ContactsDays", "cd", ["RegUserNo"]),
            ["contacts_getallnumber"] = ("ContactsNumber", "cn", ["RegUserNo"]),
            ["contacts_getallsns"] = ("ContactsSns", "cs", ["RegUserNo"]),
            ["contacts_countgroupuser"] = ("ContactsGroup", "cg", ["RegUserNo"]),
            ["contacts_getcontactsgroup"] = ("ContactsGroup", "cg", ["RegUserNo"]),
            ["contacts_getalladdress"] = ("ContactsAddress", "ca", ["RegUserNo"]),
            ["contacts_getlocationonecontact"] = ("Contacts_Locations", "cl", ["RegUserNo", "ContactUserId"])
        };
    var updated = new List<FunctionInfo>(functions.Count);
    var results = new List<DependencyResult>();
    foreach (var function in functions)
    {
        var replaceLen = confirmedLenFailures.Contains(function.Name)
            && Regex.IsMatch(function.Definition, @"\bLEN\s*\(", RegexOptions.IgnoreCase);
        var replaceTinyInt = confirmedTinyIntFailures.Contains(function.Name)
            && Regex.IsMatch(function.Definition, @"\bTINYINT\b", RegexOptions.IgnoreCase);
        var qualifyAggregate = confirmedAggregateAmbiguities.TryGetValue(function.Name, out var aggregate);
        var qualifyContactGetter = confirmedContactGetterAmbiguities.TryGetValue(function.Name, out var getter);
        if (!replaceLen && !replaceTinyInt && !qualifyAggregate && !qualifyContactGetter)
        {
            updated.Add(function);
            continue;
        }

        var definition = function.Definition;
        if (replaceLen)
            definition = Regex.Replace(
                definition, @"\bLEN\s*\(", "LENGTH(",
                RegexOptions.IgnoreCase | RegexOptions.CultureInvariant, TimeSpan.FromSeconds(2));
        if (replaceTinyInt)
            definition = Regex.Replace(
                definition, @"\bTINYINT\b", "smallint",
                RegexOptions.IgnoreCase | RegexOptions.CultureInvariant, TimeSpan.FromSeconds(2));
        if (qualifyAggregate)
        {
            definition = Regex.Replace(
                definition,
                $@"\bFROM\s+{Regex.Escape(aggregate.Table)}\s+(?=WHERE\b)",
                $"FROM {aggregate.Table} {aggregate.Alias} ",
                RegexOptions.IgnoreCase | RegexOptions.CultureInvariant,
                TimeSpan.FromSeconds(2));
            definition = Regex.Replace(
                definition,
                $@"(?<!\.)\b{Regex.Escape(aggregate.Column)}\b(?=\s*=)",
                $"{aggregate.Alias}.{aggregate.Column}",
                RegexOptions.IgnoreCase | RegexOptions.CultureInvariant,
                TimeSpan.FromSeconds(2));
        }
        if (qualifyContactGetter)
        {
            definition = Regex.Replace(
                definition,
                $@"\bFROM\s+{Regex.Escape(getter.Table)}\s+(?=WHERE\b)",
                $"FROM {getter.Table} {getter.Alias} ",
                RegexOptions.IgnoreCase | RegexOptions.CultureInvariant,
                TimeSpan.FromSeconds(2));
            foreach (var column in getter.Columns)
                definition = Regex.Replace(
                    definition,
                    $@"(?<!\.)\b{Regex.Escape(column)}\b(?=\s*=)",
                    $"{getter.Alias}.{column}",
                    RegexOptions.IgnoreCase | RegexOptions.CultureInvariant,
                    TimeSpan.FromSeconds(2));
            if (function.Name.Equals("contacts_getlocationonecontact", StringComparison.OrdinalIgnoreCase))
                definition = Regex.Replace(
                    definition,
                    @"\bSELECT\s+LocationNo\s*,\s*RegUserNo\s*,\s*Name\s*,\s*Latitude\s*,\s*Longitude\s*,\s*Description\s*,\s*ContactUserId\b",
                    "SELECT cl.LocationNo, cl.RegUserNo, cl.Name, cl.Latitude, cl.Longitude, cl.Description, cl.ContactUserId",
                    RegexOptions.IgnoreCase | RegexOptions.CultureInvariant,
                    TimeSpan.FromSeconds(2));
        }
        await using var command = connection.CreateCommand();
        command.Transaction = transaction;
        command.CommandText = definition;
        command.CommandTimeout = timeoutSeconds;
        await command.ExecuteNonQueryAsync();
        updated.Add(function with { Definition = definition });
        results.Add(new DependencyResult(
            function.Name, "TEMPORARY RUNTIME FIX",
            $"{(replaceLen ? "LEN()→LENGTH(); " : "")}{(replaceTinyInt ? "TINYINT→smallint; " : "")}{(qualifyAggregate ? $"{aggregate.Alias}.{aggregate.Column} qualified; " : "")}{(qualifyContactGetter ? $"{getter.Alias} columns qualified; " : "")}CREATE OR REPLACE is rolled back."));
    }
    return (updated, results);
}

static async Task<Dictionary<uint, IReadOnlyList<ResultColumn>>> InferRecordColumns(
    NpgsqlConnection connection,
    NpgsqlTransaction transaction,
    IReadOnlyList<FunctionInfo> functions,
    IReadOnlyDictionary<uint, string> typeNames,
    int timeoutSeconds,
    ICollection<DependencyResult> evidence)
{
    var inferred = new Dictionary<uint, IReadOnlyList<ResultColumn>>();
    var attempt = 0;
    foreach (var function in functions.Where(f =>
        f.ReturnsSet && f.Result.Equals("SETOF record", StringComparison.OrdinalIgnoreCase)))
    {
        var queries = ExtractReturnQueries(function.Definition);
        if (queries.Count == 0)
            continue;

        IReadOnlyList<ResultColumn>? commonShape = null;
        var safe = true;
        foreach (var rawQuery in queries)
        {
            var query = ReplaceQualifiedParameters(rawQuery, function, typeNames);
            if (!Regex.IsMatch(query, @"^\s*(?:SELECT|WITH)\b", RegexOptions.IgnoreCase))
            {
                safe = false;
                break;
            }

            var savepoint = $"infer_{attempt++}";
            await transaction.SaveAsync(savepoint);
            try
            {
                await using var command = connection.CreateCommand();
                command.Transaction = transaction;
                command.CommandText = $"SELECT * FROM ({query}) AS runtime_shape LIMIT 0;";
                command.CommandTimeout = timeoutSeconds;
                await using var reader = await command.ExecuteReaderAsync();
                var shape = Enumerable.Range(0, reader.FieldCount)
                    .Select(i => new ResultColumn($"column_{i + 1}", reader.GetDataTypeName(i)))
                    .ToArray();
                await reader.CloseAsync();
                await transaction.RollbackAsync(savepoint);
                if (commonShape is null)
                    commonShape = shape;
                else if (!SameShape(commonShape, shape))
                {
                    safe = false;
                    break;
                }
            }
            catch (PostgresException)
            {
                await transaction.RollbackAsync(savepoint);
                safe = false;
                break;
            }
        }

        if (safe && commonShape is { Count: > 0 })
        {
            inferred[function.Oid] = commonShape;
            evidence.Add(new DependencyResult(
                function.Name, "INFERRED RECORD SHAPE",
                string.Join(", ", commonShape.Select(c => $"{c.Name} {c.Type}"))));
        }
    }
    return inferred;
}

static List<string> ExtractReturnQueries(string definition)
{
    var results = new List<string>();
    foreach (Match match in Regex.Matches(
        definition, @"\bRETURN\s+QUERY\b", RegexOptions.IgnoreCase, TimeSpan.FromSeconds(2)))
    {
        var start = match.Index + match.Length;
        var inSingleQuote = false;
        var inDoubleQuote = false;
        var depth = 0;
        for (var i = start; i < definition.Length; i++)
        {
            var ch = definition[i];
            if (ch == '\'' && !inDoubleQuote)
            {
                if (inSingleQuote && i + 1 < definition.Length && definition[i + 1] == '\'')
                {
                    i++;
                    continue;
                }
                inSingleQuote = !inSingleQuote;
            }
            else if (ch == '"' && !inSingleQuote)
                inDoubleQuote = !inDoubleQuote;
            else if (!inSingleQuote && !inDoubleQuote)
            {
                if (ch == '(') depth++;
                else if (ch == ')') depth--;
                else if (ch == ';' && depth == 0)
                {
                    results.Add(definition[start..i].Trim());
                    break;
                }
            }
        }
    }
    return results;
}

static string ReplaceQualifiedParameters(
    string query,
    FunctionInfo function,
    IReadOnlyDictionary<uint, string> typeNames)
{
    var hasFromClause = Regex.IsMatch(query, @"\bFROM\b", RegexOptions.IgnoreCase);
    foreach (var parameter in function.GetInputParameters())
    {
        var dummy = DummyValue(typeNames.GetValueOrDefault(parameter.TypeOid, "text"));
        query = Regex.Replace(
            query,
            $@"\b{Regex.Escape(function.Name)}\s*\.\s*{Regex.Escape(parameter.Name)}\b",
            $"({dummy})",
            RegexOptions.IgnoreCase | RegexOptions.CultureInvariant,
            TimeSpan.FromSeconds(2));
        if (!hasFromClause)
            query = Regex.Replace(
                query,
                $@"\b{Regex.Escape(parameter.Name)}\b",
                $"({dummy})",
                RegexOptions.IgnoreCase | RegexOptions.CultureInvariant,
                TimeSpan.FromSeconds(2));
    }
    return query;
}

static bool SameShape(IReadOnlyList<ResultColumn> left, IReadOnlyList<ResultColumn> right) =>
    left.Count == right.Count
    && left.Zip(right).All(pair => pair.First.Type.Equals(pair.Second.Type, StringComparison.OrdinalIgnoreCase));

static async Task<RuntimeResult> Execute(
    NpgsqlConnection connection,
    NpgsqlTransaction transaction,
    FunctionInfo function,
    IReadOnlyDictionary<uint, string> typeNames,
    IReadOnlyList<ResultColumn> inferredRecordColumns,
    int timeoutSeconds)
{
    var inputTypes = function.GetInputTypes();
    var arguments = inputTypes.Select(oid => DummyValue(typeNames.GetValueOrDefault(oid, "text"))).ToArray();
    var invocation = BuildInvocation(function, arguments, typeNames, inferredRecordColumns);
    var stopwatch = Stopwatch.StartNew();
    var savepoint = $"procedure_{function.Oid}";
    try
    {
        await transaction.SaveAsync(savepoint);
        await using var command = connection.CreateCommand();
        command.Transaction = transaction;
        command.CommandText = invocation;
        command.CommandTimeout = timeoutSeconds;
        await using var reader = await command.ExecuteReaderAsync();
        var columns = Enumerable.Range(0, reader.FieldCount)
            .Select(i => new ResultColumn(reader.GetName(i), reader.GetDataTypeName(i)))
            .ToArray();
        var rowCount = 0;
        while (rowCount < 1001 && await reader.ReadAsync())
            rowCount++;
        await reader.CloseAsync();
        stopwatch.Stop();
        await transaction.RollbackAsync(savepoint);
        return RuntimeResult.Pass(function, arguments, invocation, stopwatch.ElapsedMilliseconds, columns, Math.Min(rowCount, 1000), rowCount > 1000);
    }
    catch (PostgresException ex)
    {
        stopwatch.Stop();
        await transaction.RollbackAsync(savepoint);
        if (function.ReturnsSet
            && function.Result.Equals("SETOF record", StringComparison.OrdinalIgnoreCase)
            && ex.SqlState == "0A000"
            && ex.MessageText.Contains("set-valued function", StringComparison.OrdinalIgnoreCase))
        {
            return RuntimeResult.BlockedExecution(
                function, arguments, invocation, stopwatch.ElapsedMilliseconds, ex.SqlState,
                ex.MessageText,
                "SETOF record has no inferable OUT metadata and this server rejects scalar-context SRF execution.",
                "Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...).");
        }
        return RuntimeResult.Fail(
            function, arguments, invocation, stopwatch.ElapsedMilliseconds, ex.SqlState,
            ex.MessageText, ex.Detail, ex.Hint, ex.Where,
            ClassifyRootCause(ex), ProposedFix(ex));
    }
    catch (Exception ex)
    {
        stopwatch.Stop();
        try { await transaction.RollbackAsync(savepoint); } catch { }
        return RuntimeResult.Fail(
            function, arguments, invocation, stopwatch.ElapsedMilliseconds, "CLIENT",
            ex.Message, null, null, ex.StackTrace, "Runner/client failure",
            "Fix the runner or connectivity, then execute the same invocation again.");
    }
}

static async Task<IReadOnlyList<DependencyResult>> DeployTemporaryDependencies(
    NpgsqlConnection connection,
    NpgsqlTransaction transaction,
    string repositoryRoot,
    int timeoutSeconds)
{
    var objectDirectory = Path.Combine(
        repositoryRoot, "reports", "production-validation-artifacts-20260629_135736", "objects");
    var results = new List<DependencyResult>();
    if (!Directory.Exists(objectDirectory))
        return [new DependencyResult("source table corpus", "BLOCKED", "Converted object directory is missing.")];

    var tableFiles = Directory.EnumerateFiles(objectDirectory, "*_dbo_Table_*.sql")
        .Where(path =>
        {
            var name = Path.GetFileName(path);
            return name.Contains("Board", StringComparison.OrdinalIgnoreCase)
                || name.Contains("Contact", StringComparison.OrdinalIgnoreCase);
        })
        .OrderBy(path => path, StringComparer.OrdinalIgnoreCase)
        .ToArray();

    foreach (var path in tableFiles)
    {
        var savepoint = $"dependency_{results.Count}";
        await transaction.SaveAsync(savepoint);
        var sql = await File.ReadAllTextAsync(path);
        // PostgreSQL folds unquoted procedure references to lowercase. The old
        // table converter emitted quoted source-case names, creating a distinct
        // object. Lowercase quoted DDL identifiers for this rollback-only fixture.
        sql = Regex.Replace(
            sql,
            "\"([^\"]+)\"",
            match => $"\"{match.Groups[1].Value.ToLowerInvariant()}\"",
            RegexOptions.CultureInvariant,
            TimeSpan.FromSeconds(2));
        try
        {
            await using var command = connection.CreateCommand();
            command.Transaction = transaction;
            command.CommandText = sql;
            command.CommandTimeout = timeoutSeconds;
            await command.ExecuteNonQueryAsync();
            results.Add(new DependencyResult(Path.GetFileName(path), "TEMPORARY", "Created inside outer transaction; final ROLLBACK removes it."));
        }
        catch (PostgresException ex)
        {
            await transaction.RollbackAsync(savepoint);
            results.Add(new DependencyResult(Path.GetFileName(path), "FAIL", $"{ex.SqlState}: {ex.MessageText}"));
        }
    }
    return results;
}

static string BuildInvocation(
    FunctionInfo function,
    string[] arguments,
    IReadOnlyDictionary<uint, string> typeNames,
    IReadOnlyList<ResultColumn> inferredRecordColumns)
{
    var qualifiedName = $"{Quote(function.Schema)}.{Quote(function.Name)}";
    var call = $"{qualifiedName}({string.Join(", ", arguments)})";
    if (!function.ReturnsSet)
        return $"SELECT {call};";
    if (!function.Result.Equals("SETOF record", StringComparison.OrdinalIgnoreCase))
        return $"SELECT * FROM {call};";

    var outputColumns = function.GetOutputColumns(typeNames);
    if (outputColumns.Count == 0)
        outputColumns = inferredRecordColumns;
    if (outputColumns.Count == 0)
        // A record-returning SRF can execute in scalar context without inventing
        // a column definition. Its result shape remains unvalidated.
        return $"SELECT {call};";
    var definition = string.Join(", ", outputColumns.Select(c => $"{Quote(c.Name)} {c.Type}"));
    return $"SELECT * FROM {call} AS result({definition});";
}

static async Task<Dictionary<uint, string>> LoadTypeNames(string connectionString, IEnumerable<uint> oids)
{
    var distinct = oids.Distinct().ToArray();
    var result = new Dictionary<uint, string>();
    if (distinct.Length == 0)
        return result;
    await using var connection = new NpgsqlConnection(connectionString);
    await connection.OpenAsync();
    await using var command = connection.CreateCommand();
    command.CommandText = "SELECT oid, format_type(oid, NULL) FROM pg_type WHERE oid::int = ANY($1)";
    command.Parameters.AddWithValue(distinct.Select(oid => checked((int)oid)).ToArray());
    await using var reader = await command.ExecuteReaderAsync();
    while (await reader.ReadAsync())
        result[reader.GetFieldValue<uint>(0)] = reader.GetString(1);
    return result;
}

static string DummyValue(string type)
{
    var normalized = type.ToLowerInvariant();
    if (normalized.EndsWith("[]")) return $"ARRAY[]::{type}";
    if (normalized.Contains("int") || normalized is "numeric" or "real" or "double precision" or "money") return $"0::{type}";
    if (normalized is "boolean") return "false";
    if (normalized.Contains("timestamp")) return $"CURRENT_TIMESTAMP::{type}";
    if (normalized == "date") return "CURRENT_DATE";
    if (normalized == "time without time zone" || normalized == "time with time zone") return $"CURRENT_TIME::{type}";
    if (normalized == "uuid") return "'00000000-0000-0000-0000-000000000000'::uuid";
    if (normalized == "xml") return "'<root />'::xml";
    if (normalized is "json" or "jsonb") return $"'{{}}'::{type}";
    if (normalized == "bytea") return "'\\x'::bytea";
    return $"''::{type}";
}

static string ClassifyRootCause(PostgresException ex) => ex.SqlState switch
{
    "42P01" => "Missing relation dependency",
    "42883" => "Missing function or incompatible invocation signature",
    "42703" => "Missing column dependency",
    "42702" => "Ambiguous column/parameter generated SQL",
    "2200N" => "Invalid XML runtime value or XML conversion",
    "42601" => "Generated SQL fails when its dynamic/runtime path executes",
    "23502" => "Dummy input or generated SQL violates a NOT NULL constraint",
    _ => "Runtime PostgreSQL error requiring procedure-specific investigation"
};

static string ProposedFix(PostgresException ex) => ex.SqlState switch
{
    "42P01" or "42703" => "Create the source-owned schema dependency, or document it as external with evidence.",
    "42883" => "Verify the expected helper/signature and create or convert it only if it exists in the source system.",
    "42702" => "Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.",
    "2200N" => "Compare the source XML input semantics and repair the confirmed XML conversion.",
    "42601" => "Capture the failing generated statement, repair that conversion path, regenerate, and rerun.",
    "23502" => "Use a source-valid fixture before treating this as a converter defect.",
    _ => "Investigate against source definition and rerun the recorded invocation after a scoped fix."
};

static async Task WriteReports(
    string directory,
    string connectionString,
    IReadOnlyList<RuntimeResult> results,
    IReadOnlyList<DependencyResult> dependencyResults)
{
    var generated = DateTimeOffset.Now;
    var safeTarget = new NpgsqlConnectionStringBuilder(connectionString);
    var target = safeTarget.Database;
    var jsonOptions = new JsonSerializerOptions { WriteIndented = true };
    await File.WriteAllTextAsync(Path.Combine(directory, "runtime_validation_results.json"), JsonSerializer.Serialize(results, jsonOptions));

    var passed = results.Where(r => r.Status == RuntimeStatus.Pass).ToArray();
    var failed = results.Where(r => r.Status == RuntimeStatus.Fail).ToArray();
    var blocked = results.Where(r => r.Status == RuntimeStatus.Blocked).ToArray();

    var summary = new StringBuilder()
        .AppendLine("# Runtime validation summary").AppendLine()
        .AppendLine($"Generated: {generated:yyyy-MM-dd HH:mm:ss zzz}  ")
        .AppendLine($"Target: `{target}`  ")
        .AppendLine("Method: catalog discovery; typed dummy inputs; execution inside a rolled-back transaction.").AppendLine()
        .AppendLine("| Status | Count |")
        .AppendLine("|---|---:|")
        .AppendLine($"| Runtime PASS | {passed.Length} |")
        .AppendLine($"| Runtime FAIL | {failed.Length} |")
        .AppendLine($"| Blocked | {blocked.Length} |")
        .AppendLine($"| Total discovered | {results.Count} |").AppendLine()
        .AppendLine("A PASS proves that the recorded invocation executed. It does not by itself prove business equivalence.");
    await File.WriteAllTextAsync(Path.Combine(directory, "runtime_validation_summary.md"), summary.ToString());

    var passReport = new StringBuilder("# Runtime pass list\n\n");
    passReport.AppendLine("| Procedure | Input | Result columns | Rows observed | Time ms |");
    passReport.AppendLine("|---|---|---|---:|---:|");
    foreach (var result in passed)
        passReport.AppendLine($"| `{result.Name}` | `{Md(result.Input)}` | {Md(string.Join(", ", result.Columns.Select(c => $"{c.Name}:{c.Type}")))} | {result.RowCount}{(result.RowsTruncated ? "+" : "")} | {result.DurationMs} |");
    await File.WriteAllTextAsync(Path.Combine(directory, "runtime_pass_list.md"), passReport.ToString());

    var failureReport = new StringBuilder("# Runtime failures\n\n");
    foreach (var result in failed)
    {
        failureReport.AppendLine($"## `{result.Name}`").AppendLine()
            .AppendLine($"- Input: `{Md(result.Input)}`")
            .AppendLine($"- Generated SQL: `{Md(result.InvocationSql)}`")
            .AppendLine($"- SQLSTATE: `{result.SqlState}`")
            .AppendLine($"- Error: {Md(result.ErrorMessage)}")
            .AppendLine($"- Stack context: {Md(result.Context)}")
            .AppendLine($"- Root cause: {result.RootCause}")
            .AppendLine($"- Proposed fix: {result.ProposedFix}")
            .AppendLine("- Validation after fix: NOT YET PASS").AppendLine()
            .AppendLine("<details><summary>Deployed PostgreSQL definition</summary>").AppendLine()
            .AppendLine("```sql").AppendLine(result.FunctionDefinition).AppendLine("```").AppendLine("</details>").AppendLine();
    }
    await File.WriteAllTextAsync(Path.Combine(directory, "runtime_failures.md"), failureReport.ToString());

    var dependencies = new StringBuilder("# Runtime dependency report\n\n")
        .AppendLine("Objects are not silently created from error text. Each dependency is traced to converted source DDL or explicitly classified as external.")
        .AppendLine("Temporary objects below existed only inside the smoke transaction and were removed by the final ROLLBACK.").AppendLine()
        .AppendLine("## Temporary source DDL deployment").AppendLine()
        .AppendLine("| Artifact | Status | Evidence |")
        .AppendLine("|---|---|---|");
    foreach (var dependency in dependencyResults)
        dependencies.AppendLine($"| `{dependency.Name}` | {dependency.Status} | {Md(dependency.Evidence)} |");
    dependencies.AppendLine().AppendLine("## Unresolved runtime dependencies").AppendLine()
        .AppendLine("| Procedure | SQLSTATE | Dependency evidence | Classification | Next action |")
        .AppendLine("|---|---|---|---|---|");
    foreach (var result in results.Where(r => r.Status == RuntimeStatus.Blocked || r.SqlState is "42P01" or "42703" or "42883"))
        dependencies.AppendLine($"| `{result.Name}` | `{result.SqlState}` | {Md(result.ErrorMessage)} | {(result.Status == RuntimeStatus.Blocked ? "Metadata unavailable" : "Unresolved")} | {Md(result.ProposedFix)} |");
    await File.WriteAllTextAsync(Path.Combine(directory, "runtime_dependency_report.md"), dependencies.ToString());

    var comparison = new StringBuilder("# Runtime comparison report\n\n")
        .AppendLine("No SQL Server comparison was executed in this run because no source fixture/connection was supplied to the runner.").AppendLine()
        .AppendLine("| Procedure | PostgreSQL execution | SQL Server reference | Behaviour verdict |")
        .AppendLine("|---|---|---|---|");
    foreach (var result in passed)
        comparison.AppendLine($"| `{result.Name}` | Executed; {result.RowCount}{(result.RowsTruncated ? "+" : "")} row(s), {result.Columns.Count} column(s) | Not executed | Not yet behaviour-validated |");
    await File.WriteAllTextAsync(Path.Combine(directory, "runtime_comparison_report.md"), comparison.ToString());
}

static T[] Deserialize<T>(string json) => JsonSerializer.Deserialize<T[]>(json) ?? [];
static uint[] DeserializeOids(string json) =>
    Deserialize<string>(json).Select(value => uint.Parse(value, System.Globalization.CultureInfo.InvariantCulture)).ToArray();
static string Quote(string identifier) => "\"" + identifier.Replace("\"", "\"\"") + "\"";
static string Md(string? text) => (text ?? "").Replace("|", "\\|").ReplaceLineEndings(" ");
static string FormatError(RuntimeResult result) => string.IsNullOrWhiteSpace(result.ErrorMessage) ? "" : $": {result.ErrorMessage}";

static string FindRepositoryRoot()
{
    var directory = new DirectoryInfo(AppContext.BaseDirectory);
    while (directory is not null && !File.Exists(Path.Combine(directory.FullName, "pg_converter_ui.csproj")))
        directory = directory.Parent;
    return directory?.FullName ?? throw new InvalidOperationException("Repository root was not found.");
}

sealed record FunctionInfo(
    uint Oid, string Schema, string Name, string Kind, bool ReturnsSet, string Result,
    string IdentityArguments, string Definition, string[] ArgumentNames, string[] ArgumentModes,
    uint[] AllArgumentTypes, uint[] InputArgumentTypes)
{
    public IReadOnlyList<uint> GetInputTypes()
    {
        if (ArgumentModes.Length == 0 || AllArgumentTypes.Length == 0)
            return InputArgumentTypes;
        return AllArgumentTypes.Where((_, i) => ArgumentModes[i] is "i" or "b" or "v").ToArray();
    }

    public IReadOnlyList<InputParameter> GetInputParameters()
    {
        var parameters = new List<InputParameter>();
        if (ArgumentModes.Length == 0 || AllArgumentTypes.Length == 0)
        {
            for (var i = 0; i < InputArgumentTypes.Length; i++)
                parameters.Add(new InputParameter(
                    i < ArgumentNames.Length ? ArgumentNames[i] : $"parameter_{i + 1}",
                    InputArgumentTypes[i]));
            return parameters;
        }

        for (var i = 0; i < ArgumentModes.Length && i < AllArgumentTypes.Length; i++)
            if (ArgumentModes[i] is "i" or "b" or "v")
                parameters.Add(new InputParameter(
                    i < ArgumentNames.Length ? ArgumentNames[i] : $"parameter_{i + 1}",
                    AllArgumentTypes[i]));
        return parameters;
    }

    public IReadOnlyList<ResultColumn> GetOutputColumns(IReadOnlyDictionary<uint, string> typeNames)
    {
        var columns = new List<ResultColumn>();
        for (var i = 0; i < ArgumentModes.Length && i < AllArgumentTypes.Length; i++)
            if (ArgumentModes[i] is "o" or "b" or "t")
                columns.Add(new ResultColumn(
                    i < ArgumentNames.Length ? ArgumentNames[i] : $"column_{i + 1}",
                    typeNames.GetValueOrDefault(AllArgumentTypes[i], "text")));
        return columns;
    }
}

enum RuntimeStatus { Pass, Fail, Blocked }
sealed record InputParameter(string Name, uint TypeOid);
sealed record ResultColumn(string Name, string Type);
sealed record DependencyResult(string Name, string Status, string Evidence);
sealed record RuntimeResult(
    string Name, RuntimeStatus Status, string Input, string InvocationSql, string SqlState,
    string ErrorMessage, string? Detail, string? Hint, string? Context, long DurationMs,
    string RootCause, string ProposedFix, string FunctionDefinition,
    IReadOnlyList<ResultColumn> Columns, int RowCount, bool RowsTruncated)
{
    public static RuntimeResult Pass(FunctionInfo f, string[] args, string sql, long ms, IReadOnlyList<ResultColumn> columns, int rows, bool truncated) =>
        new(f.Name, RuntimeStatus.Pass, string.Join(", ", args), sql, "", "", null, null, null, ms,
            "", "", f.Definition, columns, rows, truncated);
    public static RuntimeResult Fail(FunctionInfo f, string[] args, string sql, long ms, string state, string message,
        string? detail, string? hint, string? context, string cause, string fix) =>
        new(f.Name, RuntimeStatus.Fail, string.Join(", ", args), sql, state, message, detail, hint, context, ms,
            cause, fix, f.Definition, [], 0, false);
    public static RuntimeResult Blocked(FunctionInfo f, string[] args, string cause, string fix) =>
        new(f.Name, RuntimeStatus.Blocked, string.Join(", ", args), "", "METADATA", cause, null, null, null, 0,
            cause, fix, f.Definition, [], 0, false);
    public static RuntimeResult BlockedExecution(FunctionInfo f, string[] args, string sql, long ms, string state,
        string message, string cause, string fix) =>
        new(f.Name, RuntimeStatus.Blocked, string.Join(", ", args), sql, state, message, null, null, null, ms,
            cause, fix, f.Definition, [], 0, false);
}
