$sourceDir = "C:\Users\Admin\AppData\Local\Temp\PgConverterBoardRunner"
$targetDir = "C:\Users\Admin\AppData\Local\Temp\PgConverterSchemaRunner"

if (!(Test-Path $targetDir)) {
    New-Item -ItemType Directory -Path $targetDir | Out-Null
}

Copy-Item "$sourceDir\PgConverterBoardRunner.csproj" "$targetDir\PgConverterSchemaRunner.csproj" -Force

$programCS = @'
using System;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;
using System.Collections.Generic;
using System.Linq;
using Npgsql;

class Program
{
    const string PgHost     = "221.148.141.4";
    const int    PgPort     = 5432;
    const string PgUser     = "postgres";
    const string PgPassword = "crewcloud@core1@3$5^";
    const string PgDatabase = "pg_converter_runtime_test";

    static void Main()
    {
        var connString = $"Host={PgHost};Port={PgPort};Database={PgDatabase};Username={PgUser};Password={PgPassword};Timeout=30";
        using var conn = new NpgsqlConnection(connString);
        conn.Open();

        var objectsDir = @"E:\pg_converter_ui\reports\production-validation-artifacts-20260629_135736\objects";
        var files = new DirectoryInfo(objectsDir).GetFiles("*.sql");

        var boardTables = files.Where(f => f.Name.Contains("Table") && f.Name.Contains("Board")).OrderBy(f => f.Name).ToList();
        var boardConstraints = files.Where(f => f.Name.Contains("Constraint") && f.Name.Contains("Board")).OrderBy(f => f.Name).ToList();
        var boardIndexes = files.Where(f => f.Name.Contains("Index") && f.Name.Contains("Board")).OrderBy(f => f.Name).ToList();

        var tableResults = new List<Result>();
        Console.WriteLine("--- Testing Board Tables ---");
        foreach (var file in boardTables)
        {
            var name = file.Name;
            var sql = File.ReadAllText(file.FullName);
            var status = "PASS";
            var errorMsg = "";

            var tableName = Regex.Replace(name, @"^\d+_dbo_Table_", "");
            tableName = Regex.Replace(tableName, @"\.sql$", "");

            try
            {
                using var dropCmd = conn.CreateCommand();
                dropCmd.CommandText = $"DROP TABLE IF EXISTS public.\"{tableName}\" CASCADE;";
                dropCmd.ExecuteNonQuery();
            }
            catch {}

            try
            {
                using var cmd = conn.CreateCommand();
                cmd.CommandText = sql;
                cmd.ExecuteNonQuery();
            }
            catch (PostgresException pgEx)
            {
                status = "FAIL";
                errorMsg = pgEx.MessageText;
            }
            catch (Exception ex)
            {
                status = "FAIL";
                errorMsg = ex.Message;
            }

            tableResults.Add(new Result { Name = tableName, Status = status, Error = errorMsg });
        }

        var constraintResults = new List<Result>();
        Console.WriteLine("--- Testing Board Constraints ---");
        foreach (var file in boardConstraints)
        {
            var name = file.Name;
            var sql = File.ReadAllText(file.FullName);
            var status = "PASS";
            var errorMsg = "";

            var constraintName = Regex.Replace(name, @"^\d+_dbo_Constraint_", "");
            constraintName = Regex.Replace(constraintName, @"\.sql$", "");

            if (Regex.IsMatch(sql, @"^\s*--\s*TODO\s*:\s*Constraint\b", RegexOptions.IgnoreCase))
            {
                status = "STUB (Not converted)";
                errorMsg = "Stub file / Not converted";
            }
            else
            {
                try
                {
                    using var cmd = conn.CreateCommand();
                    cmd.CommandText = sql;
                    cmd.ExecuteNonQuery();
                }
                catch (PostgresException pgEx)
                {
                    status = "FAIL";
                    errorMsg = pgEx.MessageText;
                }
                catch (Exception ex)
                {
                    status = "FAIL";
                    errorMsg = ex.Message;
                }
            }

            constraintResults.Add(new Result { Name = constraintName, Status = status, Error = errorMsg });
        }

        var indexResults = new List<Result>();
        Console.WriteLine("--- Testing Board Indexes ---");
        foreach (var file in boardIndexes)
        {
            var name = file.Name;
            var sql = File.ReadAllText(file.FullName);
            var status = "PASS";
            var errorMsg = "";

            var indexName = Regex.Replace(name, @"^\d+_dbo_Index_", "");
            indexName = Regex.Replace(indexName, @"\.sql$", "");

            try
            {
                using var cmd = conn.CreateCommand();
                cmd.CommandText = sql;
                cmd.ExecuteNonQuery();
            }
            catch (PostgresException pgEx)
            {
                status = "FAIL";
                errorMsg = pgEx.MessageText;
            }
            catch (Exception ex)
            {
                status = "FAIL";
                errorMsg = ex.Message;
            }

            indexResults.Add(new Result { Name = indexName, Status = status, Error = errorMsg });
        }

        // Generate report
        var reportPath = @"E:\pg_converter_ui\reports\Board_Schema_Validation_Report.md";
        var md = new StringBuilder();
        md.AppendLine("# Board_% Schema DDL Validation Report");
        md.AppendLine();
        md.AppendLine("This report contains the test results of deploying Board-related table DDLs, constraint DDLs, and index DDLs to the PostgreSQL test database.");
        md.AppendLine();

        md.AppendLine("## 1. Tables Deployment Summary");
        md.AppendLine();
        md.AppendLine("| Table Name | Status | Error Details |");
        md.AppendLine("|------------|--------|---------------|");
        foreach (var r in tableResults)
        {
            md.AppendLine($"| `{r.Name}` | **{r.Status}** | {r.Error} |");
        }
        md.AppendLine();

        md.AppendLine("## 2. Constraints Deployment Summary");
        md.AppendLine();
        md.AppendLine("| Constraint Name | Status | Error Details |");
        md.AppendLine("|-----------------|--------|---------------|");
        foreach (var r in constraintResults)
        {
            md.AppendLine($"| `{r.Name}` | **{r.Status}** | {r.Error} |");
        }
        md.AppendLine();

        md.AppendLine("## 3. Indexes Deployment Summary");
        md.AppendLine();
        md.AppendLine("| Index Name | Status | Error Details |");
        md.AppendLine("|------------|--------|---------------|");
        if (indexResults.Count == 0)
        {
            md.AppendLine("No separate index DDL files found for Board tables.");
        }
        else
        {
            foreach (var r in indexResults)
            {
                md.AppendLine($"| `{r.Name}` | **{r.Status}** | {r.Error} |");
            }
        }
        md.AppendLine();

        File.WriteAllText(reportPath, md.ToString(), Encoding.UTF8);
        Console.WriteLine($"Successfully wrote Board Schema validation report to {reportPath}");
    }
}

class Result
{
    public string Name { get; set; } = "";
    public string Status { get; set; } = "";
    public string Error { get; set; } = "";
}
'@

[System.IO.File]::WriteAllText("$targetDir\Program.cs", $programCS, [System.Text.Encoding]::UTF8)
Write-Output "Successfully set up Contact schema validation runner at $targetDir"
