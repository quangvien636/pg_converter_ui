# Runtime fix report: catalog-proven string concatenation

Generated: 2026-07-03

## Result

| Gate | Before | After |
|---|---:|---:|
| Runtime PASS | 260 | **261** |
| Runtime FAIL | 72 | **71** |
| Runtime BLOCKED | 22 | **22** |
| Total routines | 354 | 354 |

All 260 baseline PASS routines remained PASS.

Recovered routine: `contacts_searchmobi`.

## Converter rule

SQL Server overloads `+` for both arithmetic and string concatenation while
PostgreSQL uses `||` for strings. The converter now resolves table aliases and
column names against the existing SQL Server table catalog. It rewrites
`left_column + right_column` only when both operands are confirmed SQL Server
string columns. Confirmed numeric pairs and unresolved operands remain
unchanged.

The operator error was removed from six routines:

- `contacts_getalluser_distinct`
- `contacts_getuser`
- `contacts_getuser_share`
- `contacts_getuserbypublicgroup`
- `contacts_getuserbysharegroup`
- `contacts_searchmobi`

The first five advanced to an existing `42804` result-shape mismatch and remain
FAIL. Those result-shape issues are outside this stabilization scope.

`board_getsubmenus` remains unchanged because its string operand is derived
from a CTE and cannot be proven from the table catalog.

## Validation

- `dotnet build pg_converter_ui.csproj -c Release`: PASS, 0 warnings/errors.
- `dotnet test tests/Regression/Regression.csproj -c Release`: 110/110 PASS.
- Board regression QA: 24/24 PASS.
- Full runtime smoke: 261 PASS / 71 FAIL / 22 BLOCKED.
- PASS regressions: 0.
