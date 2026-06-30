# Runtime Validation Report

## Scope

Runtime validation after the approved Runtime Error ID-021/022 fix only.

- Target: make the two generated PostgreSQL functions executable, not only creatable.
- No change was made to TABLE, INDEX, PROCEDURE, or OWNER conversion.
- No refactor or project-wide formatting was performed.

## Test Environment

- Test date: `2026-06-29`
- Server test host: `221.148.141.4`
- Port: `5432`
- Database: `pg_converter_runtime_test`
- User: `postgres`
- Connection string: `Host=221.148.141.4;Port=5432;User Id=postgres;Password=***;Database=pg_converter_runtime_test`
- `psql` path: `C:\Program Files (x86)\pgAdmin III\1.22\psql.exe`
- `psql` version: `psql (PostgreSQL) 9.5.5`
- PostgreSQL server/database version: `PostgreSQL 9.3.17, compiled by Visual C++ build 1600, 64-bit`
- Connection: PASS

## Runtime Error ID-021

Function:

- `fn_userlabel`

### Before

Invocation:

```sql
SELECT public.fn_userlabel('QA');
```

PostgreSQL error:

```text
column "isactive" does not exist
```

Generated signature contained only `name`; the MSSQL `@IsActive bit`
parameter was lost. The scalar body also retained T-SQL `+` string
concatenation.

ID-021 before: FAIL

### After

Generated signature and body:

```sql
CREATE OR REPLACE FUNCTION public.fn_userlabel(
    name character varying,
    isactive boolean
) RETURNS character varying
...
RETURN COALESCE(Name, '') ||
       CASE WHEN IsActive = TRUE THEN ' Active' ELSE ' Inactive' END;
```

Invocation matching the original MSSQL signature:

```sql
SELECT public.fn_userlabel('QA', TRUE);
```

Runtime result:

```text
QA Active
```

ID-021 after: PASS

## Runtime Error ID-022

Function:

- `fn_userorders`

### Before

Invocation:

```sql
SELECT * FROM public.fn_userorders(1);
```

PostgreSQL error:

```text
relation "result" does not exist
```

The MSSQL TVF return table variable `@Result` was emitted as if it were a
physical PostgreSQL table. Its declared result types were also inferred as
`text`, and its source table reference was not safely qualified.

ID-022 before: FAIL

### After

Generated return definition and body:

```sql
RETURNS TABLE(
    orderid integer,
    amount numeric
)
...
RETURN QUERY
SELECT OrderId, Amount
FROM public."Orders"
WHERE UserId = fn_userorders.userid;
```

Invocation:

```sql
SELECT * FROM public.fn_userorders(1);
```

Runtime result:

```text
orderid = 1
amount = 25.50
```

ID-022 after: PASS

## Root Causes And Approved Change

File:

- `Converter.cs`

Method:

- `Converter.ConvertFunction`

Changes limited to FUNCTION runtime conversion:

- Extract the parenthesized parameter list for scalar and table-valued functions.
- Preserve `@IsActive bit` as `isactive boolean`.
- Use PostgreSQL `||` for string-returning scalar concatenation.
- Parse declared MSSQL TVF result column names and types.
- Convert `INSERT INTO @Result SELECT ...; RETURN;` to `RETURN QUERY SELECT ...;`.
- Map qualified MSSQL table references inside function bodies to the existing PostgreSQL quoted-table convention.
- Resolve TVF output-column/column-name conflicts in PL/pgSQL.

No other repository source file was changed.

The temporary QA runner outside the repository was tightened within its
existing 27 checks to validate the corrected scalar signature/body and typed
TVF `RETURN QUERY`.

## Build

Command:

```powershell
dotnet build
```

Result: PASS

- Warnings: 0
- Errors: 0

## Automated QA

Command:

```powershell
dotnet run --project $env:TEMP\PgConverterQaRunner2\PgConverterQaRunner.csproj
```

Result: PASS

- Total checks: 27
- PASS: 27
- FAIL: 0

## Runtime SQL Execution

The `public` schema was reset. All 12 regenerated per-object SQL files were
executed with `psql -v ON_ERROR_STOP=1`.

- Total files/objects: 12
- PASS: 12
- FAIL: 0
- Tables present: 2
- Functions created: 2
- Indexes present: 8, including PRIMARY KEY indexes
- Foreign keys present: 1
- Procedures created: 0, intentionally warning-only for PostgreSQL 9.3

## Runtime Smoke Tests

| Test | Result |
|---|---|
| Insert into `public."Users"` and verify boolean default | PASS |
| Insert into `public."Orders"` through the foreign key | PASS |
| Call `fn_userlabel('QA', TRUE)` | PASS |
| Call `fn_userorders(1)` | PASS |

Runtime test totals:

- SQL files: PASS 12 / FAIL 0
- TABLE/FK smoke tests: PASS 2 / FAIL 0
- FUNCTION invocations: PASS 2 / FAIL 0
- Remaining runtime errors in the current suite: 0

## Known Limits

- SQL Server stored procedures are warning-only because PostgreSQL 9.3 has no `CREATE PROCEDURE`.
- Dynamic SQL and unsupported procedure semantics still require manual rewrite.
- `NEWID()` is warning-only unless a compatible UUID extension is explicitly available.
- Passing this sample suite does not prove correctness for every MSSQL object or syntax combination.

## Conclusion

- Build: PASS
- Automated QA: PASS 27/27
- Runtime Error ID-021: PASS
- Runtime Error ID-022: PASS
- Runtime SQL files: PASS 12/12
- Runtime smoke tests: PASS 4/4
- Overall Runtime Validation: PASS

Runtime PASS theo bộ test hiện tại trên PostgreSQL 9.3.17.

The converter is not concluded to be 100% correct for every possible MSSQL
case.
