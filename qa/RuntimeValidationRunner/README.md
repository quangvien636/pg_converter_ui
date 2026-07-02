# Runtime Validation Runner

Set the PostgreSQL connection through the environment; never commit credentials:

```powershell
$env:PG_RUNTIME_CONNECTION = "Host=...;Port=5432;Database=...;Username=...;Password=..."
dotnet run --project qa/RuntimeValidationRunner/RuntimeValidationRunner.csproj
```

The runner has a hard safety guard and refuses every database except
`pg_converter_runtime_test`.

Optional:

```powershell
$env:PG_RUNTIME_TIMEOUT_SECONDS = "30"
```

Every call runs in a transaction that is rolled back. Reports and the structured
JSON evidence are written to `reports/`.
