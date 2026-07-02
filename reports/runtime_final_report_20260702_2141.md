# Final runtime converter report - 2026-07-02 21:41 +07:00

## Outcome

| Status | Session baseline | Final |
|---|---:|---:|
| Runtime PASS | 207 | 227 |
| Runtime FAIL | 46 | 28 |
| BLOCKED | 98 | 99 |
| Discovered | 351 | 354 |

The session produced 20 additional real runtime PASS and reduced genuine FAIL
by 18. The discovered count increased because the clean rebuild harness now
deploys SQL Server procedures in addition to source functions.

## Root causes fixed

- Parameter/local-variable collisions through general variable renaming.
- SQL Server UPDATE-alias/FROM-JOIN conversion.
- Boolean, date extraction, CONVERT, concatenation, helper-split, schema-name,
  PK/default, and related general converter mappings already present in the
  accumulated working round.
- `INSERT ... VALUES` followed by a result SELECT incorrectly classified as
  `INSERT ... SELECT`.
- Final scalar/boolean SELECT missed as a procedure result.
- Table-valued return variable not folded when comments precede `RETURN`.
- Runtime rebuild omitted all `ObjectType.Procedure` objects.

## Regression coverage

- NUnit: 77/77 PASS.
- Board representative QA: 24/24 PASS.
- New patterns include UPDATE alias/JOIN, boolean inserts/comparisons,
  date-part conversion, integer split helpers, INSERT-then-result,
  standalone scalar results, XML temp targets, and commented table returns.

## Final validation

- `dotnet build`: PASS, 0 warnings, 0 errors.
- Full NUnit regression: PASS, 77/77.
- Board QA: PASS, 24/24.
- Full runtime smoke: 227 PASS / 28 FAIL / 99 BLOCKED.
- Runtime calls execute inside a transaction that is rolled back.

## Remaining failures

- Empty list strings cast to integer and empty-table MAX/sort paths: test data
  or seed dependent; changing dummy inputs reduced PASS and was rolled back.
- Named `sp_executesql` bindings embedded in dynamic SQL.
- XML `.nodes()` shredding requires a reviewed PostgreSQL XMLTABLE mapping.
- Source-owned missing helpers/relations and incompatible helper signatures.
- Remaining boolean/type and malformed dynamic-query cases need stronger
  cross-procedure evidence before introducing a broad converter rule.

No error was suppressed and no runtime PASS was fabricated.
