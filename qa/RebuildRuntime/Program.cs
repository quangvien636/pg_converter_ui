using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text.RegularExpressions;
using Microsoft.Data.SqlClient;
using Npgsql;
using pg_converter_ui;

class Program
{
    static int Main()
    {
        var msConnection = Environment.GetEnvironmentVariable("MSSQL_SOURCE_CONNECTION");
        var pgConnection = Environment.GetEnvironmentVariable("PG_RUNTIME_CONNECTION");
        var routineFilter = (Environment.GetEnvironmentVariable("PG_RUNTIME_ROUTINE_FILTER") ?? "")
            .Split(',', StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries)
            .ToHashSet(StringComparer.OrdinalIgnoreCase);
        var targetedRoutineDeploy = routineFilter.Count > 0;

        if (string.IsNullOrWhiteSpace(msConnection) || string.IsNullOrWhiteSpace(pgConnection))
        {
            Console.Error.WriteLine("Error: Connection strings must be set via environment variables.");
            return 1;
        }

        const string RequiredPgDatabase = "pg_converter_runtime_test";
        var pgSettings = new NpgsqlConnectionStringBuilder(pgConnection);
        if (!string.Equals(pgSettings.Database, RequiredPgDatabase, StringComparison.OrdinalIgnoreCase))
        {
            Console.Error.WriteLine($"Error: PG_RUNTIME_CONNECTION must target database '{RequiredPgDatabase}', got '{pgSettings.Database}'.");
            return 1;
        }

        Console.WriteLine("=== Rebuilding pg_converter_runtime_test ===");
        Console.WriteLine($"Source MSSQL Connection Configured.");
        Console.WriteLine($"Target PostgreSQL: {pgSettings.Host}:{pgSettings.Port}/{pgSettings.Database}");

        // 1. Load objects from MSSQL
        Console.WriteLine("Loading objects from MSSQL source...");
        var msBuilder = new SqlConnectionStringBuilder(msConnection);
        var (allObjects, loadError) = MssqlDbReader.Load(
            msBuilder.DataSource,
            msBuilder.InitialCatalog,
            msBuilder.IntegratedSecurity,
            msBuilder.UserID,
            msBuilder.Password,
            inclFunc: true, inclTable: true, inclIndex: true
        );

        if (!string.IsNullOrWhiteSpace(loadError))
        {
            Console.Error.WriteLine($"Error loading MSSQL metadata: {loadError}");
            return 1;
        }

        Console.WriteLine($"Loaded {allObjects.Count} objects from MSSQL.");

        // Build table catalog for SELECT * resolution
        var tableCatalog = allObjects
            .Where(o => o.Type == ObjectType.Table)
            .ToDictionary(
                o => o.Name.ToLowerInvariant(),
                o => MssqlDbReader.ParseTableRaw(o.RawBlock),
                StringComparer.OrdinalIgnoreCase);

        // Optional: verified SQL Server result-set metadata (ignored generated file), used
        // only to resolve RETURNS TABLE columns that static analysis could not infer.
        var resultMetadataCatalog = ResultMetadataCatalog.TryLoadDefault();
        Console.WriteLine($"Result metadata routines available: {resultMetadataCatalog?.Count ?? 0}");

        // 2. Reset target database schema public
        if (!targetedRoutineDeploy)
        {
            Console.WriteLine("Resetting public schema in target PostgreSQL database...");
            using var conn = new NpgsqlConnection(pgConnection);
            conn.Open();
            using var cmd = conn.CreateCommand();
            cmd.CommandText = "DROP SCHEMA IF EXISTS public CASCADE; CREATE SCHEMA public; GRANT ALL ON SCHEMA public TO public;";
            cmd.ExecuteNonQuery();
        }
        else
            Console.WriteLine($"Targeted deploy: preserving schema and replacing {routineFilter.Count} routine(s).");

        // 3. Separate objects by deployment phase
        var tables = targetedRoutineDeploy ? [] : allObjects.Where(o => o.Type == ObjectType.Table).OrderBy(o => o.Name).ToList();
        var indexes = targetedRoutineDeploy ? [] : allObjects.Where(o => o.Type == ObjectType.Index).OrderBy(o => o.Name).ToList();
        var constraints = targetedRoutineDeploy ? [] : allObjects.Where(o => o.Type == ObjectType.Constraint).OrderBy(o => o.Name).ToList();
        var views = targetedRoutineDeploy ? [] : allObjects.Where(o => o.Type == ObjectType.View).OrderBy(o => o.Name).ToList();

        // 4. Deploy Tables
        Console.WriteLine($"Deploying {tables.Count} tables...");
        int tablesDeployed = 0;
        using (var conn = new NpgsqlConnection(pgConnection))
        {
            conn.Open();
            foreach (var tbl in tables)
            {
                var sql = Converter.Convert(tbl, "postgres", tableCatalog);
                // Lowercase quoted identifiers for uniformity
                sql = Regex.Replace(sql, "\"([^\"]+)\"", m => $"\"{m.Groups[1].Value.ToLowerInvariant()}\"");
                try
                {
                    using var cmd = conn.CreateCommand();
                    cmd.CommandText = sql;
                    cmd.ExecuteNonQuery();
                    tablesDeployed++;
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"Warning: Failed to deploy table {tbl.Name}: {ex.Message}");
                    Console.WriteLine($"Generated SQL:\n{sql}\n");
                }
            }
        }
        Console.WriteLine($"Tables deployed: {tablesDeployed}/{tables.Count}");

        // 5. Deploy Constraints
        Console.WriteLine($"Deploying {constraints.Count} constraints (PKs/FKs)...");
        int constraintsDeployed = 0;
        using (var conn = new NpgsqlConnection(pgConnection))
        {
            conn.Open();
            foreach (var cons in constraints)
            {
                var sql = Converter.Convert(cons, "postgres", tableCatalog);
                if (Regex.IsMatch(sql, @"^\s*--\s*TODO\s*:\s*Constraint\b", RegexOptions.IgnoreCase))
                    continue; // Skip unimplemented constraints

                sql = Regex.Replace(sql, "\"([^\"]+)\"", m => $"\"{m.Groups[1].Value.ToLowerInvariant()}\"");
                try
                {
                    using var cmd = conn.CreateCommand();
                    cmd.CommandText = sql;
                    cmd.ExecuteNonQuery();
                    constraintsDeployed++;
                }
                catch (Exception ex)
                {
                    // Some FKs might fail if parent tables are missing, which is expected for out-of-scope tables
                    // Log warning but don't fail
                }
            }
        }
        Console.WriteLine($"Constraints deployed: {constraintsDeployed}/{constraints.Count}");

        // 6. Deploy Indexes
        Console.WriteLine($"Deploying {indexes.Count} indexes...");
        int indexesDeployed = 0;
        using (var conn = new NpgsqlConnection(pgConnection))
        {
            conn.Open();
            foreach (var idx in indexes)
            {
                var sql = Converter.Convert(idx, "postgres", tableCatalog);
                sql = Regex.Replace(sql, "\"([^\"]+)\"", m => $"\"{m.Groups[1].Value.ToLowerInvariant()}\"");
                try
                {
                    using var cmd = conn.CreateCommand();
                    cmd.CommandText = sql;
                    cmd.ExecuteNonQuery();
                    indexesDeployed++;
                }
                catch (Exception ex)
                {
                    // Ignore index creation failures on missing columns/tables
                }
            }
        }
        Console.WriteLine($"Indexes deployed: {indexesDeployed}/{indexes.Count}");

        // 7. Deploy Views
        Console.WriteLine($"Deploying {views.Count} views...");
        int viewsDeployed = 0;
        using (var conn = new NpgsqlConnection(pgConnection))
        {
            conn.Open();
            foreach (var view in views)
            {
                var sql = Converter.Convert(view, "postgres", tableCatalog);
                sql = Regex.Replace(sql, "\"([^\"]+)\"", m => $"\"{m.Groups[1].Value.ToLowerInvariant()}\"");
                try
                {
                    using var cmd = conn.CreateCommand();
                    cmd.CommandText = sql;
                    cmd.ExecuteNonQuery();
                    viewsDeployed++;
                }
                catch (Exception ex)
                {
                    // Views might have references to missing tables/views
                }
            }
        }
        Console.WriteLine($"Views deployed: {viewsDeployed}/{views.Count}");

        // 8. Deploy Functions
        // SQL Server stored procedures are converted to PostgreSQL functions too.
        // Omitting ObjectType.Procedure silently left the runtime database with
        // only scalar/table-valued source functions after a clean rebuild.
        var functions = allObjects
            .Where(o => o.Type is ObjectType.Function or ObjectType.Procedure)
            .Where(o => !targetedRoutineDeploy || routineFilter.Contains(o.Name))
            .ToList();
        Console.WriteLine($"Deploying {functions.Count} routines as PostgreSQL functions...");
        int functionsDeployed = 0;
        using (var conn = new NpgsqlConnection(pgConnection))
        {
            conn.Open();
            foreach (var fn in functions)
            {
                var sql = Converter.Convert(fn, "postgres", tableCatalog, resultMetadataCatalog);
                try
                {
                    using var cmd = conn.CreateCommand();
                    cmd.CommandText = sql;
                    cmd.ExecuteNonQuery();
                    functionsDeployed++;
                }
                catch (Exception ex)
                {
                    // Some helper functions might fail if they reference missing tables or have unresolved constructs, which is fine
                }
            }
        }
        Console.WriteLine($"Functions deployed: {functionsDeployed}/{functions.Count}");

        Console.WriteLine("Rebuild process completed successfully.");
        return 0;
    }
}
