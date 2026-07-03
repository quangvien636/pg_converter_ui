# Converter Runtime Improvement Walkthrough

## 2026-07-03 - SQL Server result metadata unblocks SETOF record routines

- Runtime before: 229 PASS / 20 FAIL / 105 BLOCKED (354 discovered).
- Runtime after: **238 PASS / 95 FAIL / 21 BLOCKED** (354 discovered).
- Zero regressions: diffed every routine by name against the prior baseline —
  all 229 previously-PASS and all 20 previously-FAIL routines kept their
  exact status. Every status change came from the 105 previously-BLOCKED
  routines: 9 moved to PASS, 75 moved to FAIL (now callable but expose
  pre-existing body/dependency issues that were invisible while BLOCKED),
  21 remain BLOCKED (no trustworthy metadata available).
- Root cause of the extractor failing 105/105 last session: the source SQL
  Server is 2008/2008 R2, which predates both
  `sys.dm_exec_describe_first_result_set_for_object` and
  `sys.sp_describe_first_result_set` (SQL Server 2012+). Added a `SET FMTONLY
  ON` fallback in `qa/SqlServerResultMetadata`, wrapped in a transaction that
  is always rolled back as a safety net against FMTONLY's documented
  tendency to still execute statement shapes it doesn't recognize. Extraction
  now succeeds for 104/105 requested routines, all with fully-mapped column
  types (0 unmapped).
- `Converter.cs` now accepts an optional verified result-metadata catalog
  (loaded from the gitignored `reports/generated/sqlserver_result_metadata.json`)
  and resolves `RETURNS TABLE(...)` for procedures/functions whose column
  shape static analysis cannot determine. Applied only when extraction
  status is `Success` and every column has a trustworthy PostgreSQL type —
  anything incomplete stays `SETOF record`/BLOCKED, never guessed.
- First live rebuild against real metadata found two further defects that
  were silently preventing 13 routines from deploying at all (CREATE
  FUNCTION failed and was swallowed): an unquoted PostgreSQL reserved column
  name (`Position`) and procedures whose result set legitimately repeats a
  column name (`IsNotice, IsNotice`), which `RETURNS TABLE` forbids. Fixed
  by reusing the existing `QuoteIfReserved` helper and refusing to emit
  `RETURNS TABLE` when a routine has duplicate result column names.
- Known limitation (affects 6 of the 75 new FAILs): a handful of procedures
  (e.g. `Contacts_GetUserData`) branch on a parameter and return a
  *different* column shape per branch. Every schema-description API SQL
  Server offers — including the FMTONLY fallback — can only report one
  representative shape, so the generated `RETURNS TABLE` is accurate for
  only some branches. This surfaces as an honest PostgreSQL error
  (`structure of query does not match function result type`) rather than a
  silent wrong result, so it does not violate the no-fake-PASS rule, but it
  is not fixable by better metadata alone — it needs per-branch handling
  (e.g. multiple functions, or `SETOF record` kept deliberately) and was
  left as BLOCKED-equivalent (correctly failing) rather than guessed.
- Validation: build PASS with 0 warnings/errors; NUnit 95/95; Board QA
  24/24; full rollback-only runtime smoke 238/95/21.
- Next: investigate the 75 new FAILs by error class (ambiguous column
  references, missing `parsejson()` helper, missing `user_depart`/`folder`
  relations) — these are pre-existing converter/body-conversion gaps now
  visible for the first time, unrelated to result metadata.

## 2026-07-03 - Final handoff verification

- Final verified baseline: **229 PASS / 20 FAIL / 105 BLOCKED** from 354
  discovered routines.
- Build PASS with 0 warnings/errors; NUnit 81/81; Board QA 24/24.
- Commits since `ec3a9eb`: `51e3410`, `5a46ff3`, `de6d74c`, and `6a740b5`.
- Net improvement since `ec3a9eb`: 2 additional runtime PASS and 8 fewer
  runtime FAIL.
- Broader catalog return inference, partial dynamic SQL repairs, and
  text/integer comparison coercion were rolled back when the complete runtime
  gate did not improve or a non-deployable helper was exposed.
- No further safe generalized converter fix remains without authoritative
  result metadata, helper deployment/signature mappings, dynamic binding
  metadata, or missing source relation schemas.
- Full handoff: `reports/final_runtime_handoff_20260703.md`.

## 2026-07-03 - Temp-table numeric INSERT typing

- Runtime before: 228 PASS / 22 FAIL / 104 BLOCKED.
- Runtime after: **229 PASS / 20 FAIL / 105 BLOCKED**.
- General rule: parse locally declared temp-table schemas and preserve SQL
  Server's implicit text-to-number conversion only when a known text parameter
  or `SUBSTRING` expression is inserted into a declared numeric temp column.
- Permanent tables, unknown expressions, and nonnumeric temp columns are
  untouched.
- `contacts_updatecontactsuser` moved to PASS.
- `contacts_setcontactsuser` cleared its `groupno` type failure and is now
  BLOCKED only by non-inferable `SETOF record` metadata.
- Validation: build PASS with 0 warnings/errors; NUnit 81/81; Board QA 24/24;
  full rollback-only runtime smoke 229/20/105.

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
