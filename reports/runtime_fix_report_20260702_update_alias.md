# Runtime Fix Report - UPDATE Alias/FROM JOIN

## Metrics

| Metric | Before | After |
|---|---:|---:|
| Runtime PASS | 207 | Pending full runtime |
| Runtime FAIL | 46 | Pending full runtime |
| Runtime BLOCKED | 98 | Pending full runtime |
| NUnit | 68 PASS | 74 PASS |
| Board compile QA | 162 PASS | 162 PASS |

## Change

Resolved the general T-SQL `UPDATE alias FROM target alias INNER JOIN source`
scope mismatch. PostgreSQL output now targets the real table, retains the
target alias, keeps the source in `FROM`, and combines JOIN/WHERE predicates.

- Expected routines improved: 6 (`BW`/`G` relation failures).
- Files: `Converter.cs`, `tests/Regression/RegressionTests.cs`.
- Regression added: UPDATE alias with target/source JOIN.
- Runtime validation: **pending**; the standard runner requires
  `PG_RUNTIME_CONNECTION`, which is unavailable in this session.

## Remaining groups

- Missing helpers/dependencies: 12.
- Syntax/no-destination: 10, containing multiple distinct semantic patterns.
- Missing relations/temp scope: 7 before this rule; six are expected fixed.
- Type/data failures: boolean/type casts, invalid dummy data, NOT NULL data.

## Next step

Classify result-producing SELECTs in `RETURNS void` routines by provenance
(business result, XML placeholder, CTE/temp materialization) and implement only
the semantics-preserving cases.
