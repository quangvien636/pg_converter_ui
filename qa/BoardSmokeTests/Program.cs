using Npgsql;

const string connectionString =
    "Host=221.148.141.4;Port=5432;Database=pg_converter_runtime_test;" +
    "Username=postgres;Password=crewcloud@core1@3$5^;Timeout=30;Command Timeout=10";

var candidates = new List<(string Name, string Arguments, string Result)>();
await using (var connection = new NpgsqlConnection(connectionString))
{
    await connection.OpenAsync();
    await using var command = connection.CreateCommand();
    command.CommandText = """
        SELECT p.proname, oidvectortypes(p.proargtypes), pg_get_function_result(p.oid)
        FROM pg_proc p
        WHERE p.pronamespace = (SELECT oid FROM pg_namespace WHERE nspname = 'public')
          AND p.proname LIKE 'board_%'
          AND pg_get_function_result(p.oid) !~* '\mrecord\M'
        ORDER BY p.proname
        """;
    await using var reader = await command.ExecuteReaderAsync();
    while (await reader.ReadAsync())
        candidates.Add((reader.GetString(0), reader.GetString(1), reader.GetString(2)));
}

var passed = new List<string>();
var failed = new List<(string Name, string Error)>();
foreach (var candidate in candidates)
{
    await using var connection = new NpgsqlConnection(connectionString);
    await connection.OpenAsync();
    await using var transaction = await connection.BeginTransactionAsync();
    try
    {
        await using var command = connection.CreateCommand();
        command.Transaction = transaction;
        command.CommandTimeout = 10;
        string arguments = string.Join(", ", candidate.Arguments
            .Split(',', StringSplitOptions.TrimEntries | StringSplitOptions.RemoveEmptyEntries)
            .Select(type => $"NULL::{type}"));
        command.CommandText =
            $"SELECT * FROM public.\"{candidate.Name.Replace("\"", "\"\"")}\"({arguments}) LIMIT 1";
        await command.ExecuteNonQueryAsync();
        passed.Add(candidate.Name);
    }
    catch (Exception ex)
    {
        failed.Add((candidate.Name, ex.Message.ReplaceLineEndings(" ")));
    }
    finally
    {
        await transaction.RollbackAsync();
    }
}

Console.WriteLine($"Board smoke candidates: {candidates.Count}");
Console.WriteLine($"Board smoke PASS: {passed.Count}");
Console.WriteLine($"Board smoke FAIL: {failed.Count}");
foreach (var failure in failed)
    Console.WriteLine($"FAIL {failure.Name}: {failure.Error}");

return failed.Count == 0 ? 0 : 1;
