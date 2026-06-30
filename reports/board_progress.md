# Board_% Progress

**Date:** 2026-06-30  
**Scope:** only SQL Server procedures whose names start with `Board_`  
**Target:** `pg_converter_runtime_test`

## Final status

| Metric | Count |
|---|---:|
| Total Board_% procedures | 162 |
| Conversion PASS | 162 |
| Compile PASS | 162 |
| Compile FAIL | 0 |
| Compile PASS increase | +1 |
| Regression tests | 31/31 PASS |
| Board representative regression | 24/24 PASS |

Stop condition reached: all 162 discovered `Board_%` procedures compile on PostgreSQL.

## Compile iterations

### Baseline

| Metric | Count |
|---|---:|
| Total | 162 |
| PASS | 161 |
| FAIL | 1 |
| PASS increase | 0 |

- Object: `Board_GetTreeSubMenu_V2_Json`
- PostgreSQL error: `42601: syntax error at or near "XML"`
- Root cause: SQL Server string aggregation using `FOR XML PATH(N''), TYPE).value(...)` was emitted unchanged.

### Iteration 1

| Metric | Count |
|---|---:|
| Total | 162 |
| PASS | 161 |
| FAIL | 1 |
| PASS increase | 0 |

- The first XML conversion handled non-Unicode literals but the production procedure uses `N''`, `N'.'`, and `N'NVARCHAR(MAX)'`.
- PostgreSQL error remained `42601: syntax error at or near "XML"`.
- Regression: PASS.

### Iteration 2

| Metric | Count |
|---|---:|
| Total | 162 |
| PASS | 162 |
| FAIL | 0 |
| PASS increase | +1 |

- Fixed object: `Board_GetTreeSubMenu_V2_Json`
- Root cause fixed: Unicode `FOR XML PATH` string aggregation.
- Conversion: `FOR XML PATH(...).value(...)` to ordered `array_to_string(ARRAY(SELECT ...), '')`.
- Added mapping for `CAST(... AS NVARCHAR(n|MAX))` to PostgreSQL `text`.
- PostgreSQL error after fix: none.
- Regression: 31/31 and Board 24/24 PASS.

## Converter files changed

- `BodyConverter.cs`
  - Added balanced-parenthesis scanning for SQL strings/comments.
  - Added Board-only `FOR XML PATH` aggregation conversion.
  - Supports Unicode `N'...'` XML arguments.
- `Converter.cs`
  - Added `NVARCHAR`/`VARCHAR` cast mapping inside `CAST`.
- `qa/BoardRegressionTests/Program.cs`
  - Added regression coverage for `Board_GetTreeSubMenu_V2_Json`.
- `qa/BoardSmokeTests/`
  - Added rollback-only runtime smoke runner for callable `Board_%` functions.

## Runtime smoke result

Smoke calls were executed inside transactions and rolled back.

| Metric | Count |
|---|---:|
| Callable non-record candidates | 46 |
| Smoke PASS | 0 |
| Smoke FAIL | 46 |

Failure breakdown:

| PostgreSQL error | Count | Assessment |
|---|---:|---|
| `42P01` missing relation / FROM entry | 42 | Runtime database lacks required Board/dependency tables |
| `42702` ambiguous column | 2 | Runtime converter issue in `Board_SetContentSetting`, `Board_SetHistoryFolder` |
| `23502` NOT NULL violation | 1 | Smoke supplied NULL arguments to `Board_InsertBoard` |
| `42601` no destination for result data | 1 | Runtime issue in `Board_UpdateNotificationService` |

These failures do not change the compile result. Runtime smoke cannot pass in the current target database until its required table schema and cross-module dependencies are provisioned. No non-Board object was modified or deployed in this session.

## GitHub checkpoint

- Pre-fix checkpoint: `6a1b1d3`
- Remote: `quangvien636/video-pipeline`
- Branch: `pg_converter_ui`
