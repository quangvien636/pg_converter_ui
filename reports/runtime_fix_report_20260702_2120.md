# Runtime converter fix report - 2026-07-02 21:20 +07:00

## Counts

| Status | Before | After |
|---|---:|---:|
| Runtime PASS | 221 | 224 |
| Runtime FAIL | 35 | 32 |
| BLOCKED | 98 | 98 |

Three procedures were rescued:

- `contacts_updatecontactgroupuser`
- `contacts_updatepublicgroupuser`
- `contacts_updatesharegroupuser`

## Root cause and general rule

`HasResultReturningSelect` removed a standalone result SELECT when it followed
an `INSERT ... VALUES` line. It incorrectly classified the two statements as a
multiline `INSERT ... SELECT`, emitted `RETURNS void`, and PostgreSQL raised
`query has no destination for result data`.

The multiline INSERT-source rule now refuses to cross an INSERT that already
contains `VALUES`. The following result SELECT is preserved and converted with
`RETURN QUERY`.

## Changed files

- `Converter.cs`
- `tests/Regression/RegressionTests.cs`
- `qa/RebuildRuntime/Program.cs`
- `qa/BoardRegressionTests/Program.cs`
- `walkthrough.md`

## Regression and validation

- New regression: `TestInsertValuesFollowedByResultSelectReturnsRows`.
- `dotnet build`: PASS, 0 warnings, 0 errors.
- NUnit regression: PASS, 75/75.
- Board QA: PASS, 24/24.
- Full runtime smoke: PASS as a measurement run; 224 PASS / 32 FAIL /
  98 BLOCKED. The runner exits nonzero because genuine FAIL results remain.

## Remaining failures and next step

The largest remaining exact error is `invalid input syntax for integer: ""`
(five routines), followed by four destinationless SELECT failures and four
not-null `sort` failures. Next, separate XML/temp-table materialization SELECTs
from true result SELECTs and repair the remaining Board result-flow cases.
