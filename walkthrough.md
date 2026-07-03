# Converter Runtime Improvement Walkthrough

## 2026-07-03 - Exact temp-table RETURNS TABLE inference

- Runtime before: 227 PASS / 22 FAIL / 105 BLOCKED.
- Runtime after: **228 PASS / 22 FAIL / 104 BLOCKED**.
- General rule: when a procedure's final result is exactly `SELECT *` from a
  locally declared temp table, infer `RETURNS TABLE` only if every temp-table
  column name and type parses into a known PostgreSQL type.
- No expression types or result names are guessed. Unsupported definitions
  continue to use `SETOF record`.
- Recovered `board_getdepartandpositionname`, whose two output columns are
  proven by its local `_tmp` declaration.
- Validation: build PASS with 0 warnings/errors; NUnit 80/80; Board QA 24/24;
  full rollback-only runtime smoke 228/22/104.

## 2026-07-03 - Optional INTO in boolean INSERT mapping

- Runtime before: 227 PASS / 23 FAIL / 104 BLOCKED.
- Runtime after: **227 PASS / 22 FAIL / 105 BLOCKED**.
- Root cause: SQL Server permits `INSERT Table (...) VALUES (...)`; the
  boolean-column mapper only recognized `INSERT INTO Table`, even though a
  later conversion phase added `INTO`.
- General fix: boolean INSERT literal mapping now accepts both SQL Server
  forms and still maps only confirmed boolean-style column names.
- Cleared the `Enabled integer` runtime failure in
  `board_insertboardcontent`. The routine is now BLOCKED only because its
  `SETOF record` output metadata cannot be inferred safely.
- Validation: build PASS with 0 warnings/errors; NUnit 79/79; Board QA 24/24;
  full rollback-only runtime smoke 227/22/105.

## 2026-07-03 - Integer SUBSTRING assignment coercion

- Runtime before: 227 PASS / 28 FAIL / 99 BLOCKED.
- Runtime after: **227 PASS / 23 FAIL / 104 BLOCKED**.
- Root cause: five Contacts list-parsing routines assigned an empty
  `SUBSTRING(...)` result to a declared integer. SQL Server coerces that value
  to zero, while PostgreSQL raises `22P02`.
- General fix: integer-declared local variables now preserve SQL Server's
  empty-string coercion for `SUBSTRING` assignments. Text variables are left
  unchanged.
- Cleared converter failures in `contacts_getoutfile`,
  `contacts_getoutfileexcel`, `contacts_getoutlist`,
  `contacts_getoutlistcount`, and `contacts_getoutlistexcel`. They are now
  classified BLOCKED because their `SETOF record` result columns cannot be
  inferred safely by the runtime runner.
- Validation: build PASS with 0 warnings/errors; NUnit 78/78; Board QA 24/24;
  full rollback-only runtime smoke 227/23/104.

## 2026-07-02 21:41 - Final validation

- Session baseline: 207 PASS / 46 FAIL / 98 BLOCKED (351 discovered).
- Final: **227 PASS / 28 FAIL / 99 BLOCKED** (354 discovered).
- Net result: 20 additional real runtime PASS and 18 fewer runtime FAIL.
- Final validation: build PASS with 0 warnings/errors; NUnit 77/77; Board QA
  24/24; full rollback-only runtime smoke 227/28/99.
- Remaining failures are dominated by empty/missing seed data, unresolved
  dynamic SQL bindings, XML shredding requiring business mapping, source helper
  dependencies, and a small number of type/syntax patterns that cannot be
  generalized safely from the available evidence.

## 2026-07-02 21:37 - Table-valued return variables

- Runtime before: 225 PASS / 30 FAIL / 99 BLOCKED.
- Runtime after: **227 PASS / 28 FAIL / 99 BLOCKED**.
- Root cause: comments between `INSERT INTO @ReturnTable SELECT ...` and
  `RETURN` prevented conversion to `RETURN QUERY`, so PostgreSQL tried to use
  the return variable as a physical relation.
- General fix: table-valued return folding now accepts intervening line
  comments and whitespace.
- Rescued `board_getboardallow` and `board_getfolderallow`.
- Validation: build PASS; NUnit 77/77; Board QA 24/24; full runtime smoke
  227/28/99.

## 2026-07-02 21:26 - Board scalar result detection

- Runtime before: 224 PASS / 32 FAIL / 98 BLOCKED.
- Runtime after: **225 PASS / 30 FAIL / 99 BLOCKED**.
- General fix: recognize converted standalone scalar/boolean SELECT lines as
  real result sets when raw-body heuristics miss them.
- `board_updateallowaccess` moved to PASS; `board_updatespectype` moved from
  FAIL to BLOCKED because its `SETOF record` result shape cannot yet be inferred
  safely by the runner. Two XML notification routines remain FAIL and were not
  hidden with `PERFORM`.
- Validation: build PASS; NUnit 76/76; Board QA 24/24; full runtime smoke
  225/30/99.

## 2026-07-02 21:20 - Preserve result SELECT after INSERT VALUES

- Runtime before: 221 PASS / 35 FAIL / 98 BLOCKED (354 discovered).
- Runtime after: **224 PASS / 32 FAIL / 98 BLOCKED**.
- Root cause: result detection treated `INSERT ... VALUES` followed by a
  standalone `SELECT` as a multiline `INSERT ... SELECT`, so three Contacts
  procedures were emitted as `RETURNS void`.
- General fix: multiline INSERT-source detection now stops when the INSERT
  already contains `VALUES`; the following SELECT is retained as a result set.
- Added NUnit regression for `INSERT ... VALUES` followed by a result SELECT.
- Validation: build PASS; NUnit 75/75; Board QA 24/24; full runtime smoke PASS
  with three additional runtime PASS and no regression.
- Runtime rebuild QA now deploys SQL Server procedures as PostgreSQL functions
  and supports guarded targeted routine redeployment without resetting schema.
- Next: distinguish XML/temp-table materialization SELECTs from true result
  SELECTs, then address the remaining Board no-destination failures.

## 2026-07-02 - UPDATE alias/FROM JOIN

- Baseline: 207 PASS / 46 FAIL / 98 BLOCKED.
- Root cause: SQL Server accepts `UPDATE alias ... FROM target alias JOIN source`;
  PostgreSQL requires the target table after `UPDATE` and must not repeat it in
  `FROM`.
- Added a general conversion rule that promotes the real target table, preserves
  its alias, removes the duplicate target from `FROM`, and moves the join
  predicate into `WHERE`.
- Added regression coverage for the general UPDATE-alias/JOIN shape.
- Build: PASS, 0 warnings/errors.
- NUnit: 74/74 PASS.
- Board compile QA: 162/162 PASS.
- Full runtime: **Runtime validation pending** because
  `PG_RUNTIME_CONNECTION` is not configured for the standard runner.
- Expected improvement: the six known `relation "bw"/"g" does not exist`
  failures.
- Next: separate void-function result SELECTs from XML placeholders and
  temp-table/CTE SELECTs before implementing a safe no-destination rule.
