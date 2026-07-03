# Converter Runtime Improvement Walkthrough

## 2026-07-03 - Catalog-proven string column concatenation

- Runtime before: **260 PASS / 72 FAIL / 22 BLOCKED** (354 discovered).
- Runtime after: **261 PASS / 71 FAIL / 22 BLOCKED** (354 discovered).
- Recovered: `contacts_searchmobi`.
- Zero regressions: all 260 previously passing routines remained PASS.
- Added a catalog-driven rule that changes `column_a + column_b` to
  `column_a || column_b` only when both operands resolve to SQL Server string
  columns in tables referenced by the routine. Qualified aliases and
  unqualified columns are supported; numeric and unresolved operands are left
  unchanged.
- The rule removed the string-operator failure from six routines. Five now
  advance to their pre-existing `42804` result-shape mismatch and remain FAIL;
  these are excluded from further converter work by the polymorphic result
  shape stop condition.
- `board_getsubmenus` still has `text + text` through a CTE-derived column. It
  is not rewritten by this rule because the table catalog cannot prove that
  CTE output type.
- Validation: Release build PASS with 0 warnings/errors; NUnit 110/110; Board
  QA 24/24; runtime 261/71/22.
- Detailed evidence: `reports/runtime_fix_report_20260703_catalog_string_concat.md`.

## 2026-07-03 — Runtime stabilization checkpoint (FINAL)

**Checkpoint timestamp:** 2026-07-03 16:05 +07:00

| Gate | Result |
|---|---:|
| Product build | PASS, 0 warnings/errors |
| NUnit regression | **108/108 PASS** |
| Board representative QA | **24/24 PASS** |
| Runtime PASS | **260** |
| Runtime FAIL | **72** |
| Runtime BLOCKED | **22** |
| Total routines discovered | 354 |

Runtime validation used catalog discovery, typed dummy inputs executed inside
a rolled-back transaction. A PASS proves the invocation executed; it does not
by itself prove business equivalence.

**Security remediation applied this session** (separate commit `423dee0`):
- `scratch/` (38 files, some containing plaintext credentials) removed from
  git tracking via `git rm --cached`; now gitignored
- `reports/production-validation-artifacts-*/` (15,860 customer schema files)
  removed from git tracking; now gitignored
- `reports/schema_snapshots/`, `reports/runtime-logs/`, `*.log` also gitignored
- `reports/runtime-validation.md` sanitised: server host, database name, user,
  and connection string redacted
- No local files deleted; no history rewritten

---

## 2026-07-03 - Runtime stabilization session summary and triage

- Session start: 238 PASS / 95 FAIL / 21 BLOCKED (354 discovered).
- Session end: **260 PASS / 72 FAIL / 22 BLOCKED** (354 discovered).
- Six generalized converter fixes landed, each independently verified against
  the live runtime database with zero PASS regressions (full detail in the
  entries below): `#variable_conflict use_column` for `RETURNS TABLE`
  functions, generalized `ParseJson` conversion, `COUNT(...)` integer casts,
  boolean-parameter literal comparisons, the `ParseJson` fallback `COALESCE`
  text cast, and `WITH RECURSIVE` for self-referencing CTEs.
- Full triage of the remaining 72 FAILs — why no further blanket rule was
  attempted, and prioritized recommended next work — is in
  `reports/runtime_fail_triage_20260703.md`. Summary: the largest remaining
  buckets are a genuine dependency gap (missing SQL-Server-side helper
  functions not yet converted) and a structural limitation (multi-branch
  polymorphic procedures that no schema-description API can capture in one
  shape) — neither is a converter bug fixable by a blanket rule. One real,
  scoped opportunity remains: SQL Server's `SELECT @var = expr` leaves the
  variable unchanged when no row matches, while PostgreSQL's `SELECT INTO`
  always sets it to NULL — a confirmed 4-routine NOT NULL violation cluster
  that needs `DECLARE`-default tracking to fix safely.

## 2026-07-03 - WITH RECURSIVE for self-referencing CTEs (and a hang fix)

- Runtime before: 256 PASS / 76 FAIL / 22 BLOCKED (354 discovered).
- Runtime after: **260 PASS / 72 FAIL / 22 BLOCKED** (354 discovered).
- Zero regressions: all 256 previously-PASS routines stayed PASS, all 22
  BLOCKED routines stayed BLOCKED.
- Root cause of the mission-flagged `user_depart`/`folder`/`rootdeparts`
  missing-relation failures: SQL Server infers a recursive CTE
  automatically; PostgreSQL requires the `WITH` clause to say
  `WITH RECURSIVE` explicitly. Without it, the recursive branch's
  self-join fails with "relation X does not exist".
- Found there was already an attempted fix for this in the converter —
  and it was broken two ways: (1) it checked for a self-reference by
  scanning from the CTE's own opening paren to the **end of the entire
  function body**, not just the CTE's own definition, so it keyed off
  whether the CTE name was referenced *anywhere later* — including by
  its own normal consuming `SELECT`, which is not a self-reference at
  all; (2) it required literal whitespace between `WITH`/name/`AS`/`(`,
  so it silently never fired on this codebase's heavily-commented CTE
  headers (multi-line `-- ...` blocks between every token). Removed and
  replaced with `AddRecursiveToSelfReferencingCte`, which walks each
  comma-separated `name AS (...)` entry via the existing
  `FindClosingParenthesis` helper and checks only that CTE's own body.
- **Hang discovered and fixed mid-flight**: the first version of the
  replacement used a regex "gap" group (`(?:\s|--[^\r\n]*)*`) to skip
  comments/whitespace between tokens. Against `board_getboards` — a
  large, heavily-commented, 9-CTE real procedure — this caused
  catastrophic backtracking once the match failed against the trailing
  final `SELECT` (full of `... AS ...` column-alias false starts),
  effectively hanging the runtime rebuild for over 50 minutes before it
  was noticed and killed. Replaced the regex gap with
  `SkipCommentsAndWhitespace`, a plain linear character scan with no
  backtracking risk. Verified by converting all 2516 source routines
  standalone: completes in under two minutes with no hangs, and by
  timing each of the 6 affected routines individually (worst case 851 ms
  for `board_getboards`, all correctly flagged recursive).
- Validation: build PASS with 0 warnings/errors; NUnit 108/108; Board QA
  24/24; full rollback-only runtime smoke 260/72/22.
- Process note: when the subsequent full rebuild appeared stalled, the
  actual `dotnet run --project qa/RebuildRuntime` process (identified via
  its command line, not just "a dotnet.exe") was terminated directly
  rather than the whole session restarting; only the rebuild step was
  re-run once the fix was verified.
- Remaining FAIL breakdown by SQLSTATE (72 total): `42883` (~30, mostly
  missing SQL-Server-side helper functions — a dependency gap), `42804`
  (~21, genuine multi-branch polymorphic procedures), `42P01` missing
  relation (1 remaining — `_androiddevices`, a different, non-CTE cause),
  `23502` NOT NULL violation (5), `42601` dynamic SQL syntax (5), `42703`
  missing column (5), `42P19` (1), `22012` (1).
- Next: no further single clean converter-owned pattern identified
  without deeper per-routine investigation. A dependency/triage report
  for the remaining `42883`/`42804` buckets is the more appropriate next
  artifact.

## 2026-07-03 - Cast ParseJson language-fallback COALESCE to text

- Runtime before: 250 PASS / 82 FAIL / 22 BLOCKED (354 discovered).
- Runtime after: **256 PASS / 76 FAIL / 22 BLOCKED** (354 discovered).
- Zero regressions: all 250 previously-PASS routines stayed PASS, all 22
  BLOCKED routines stayed BLOCKED.
- Investigated the remaining `42804` bucket (27 `structure of query`
  failures) by querying live PostgreSQL error `Detail` for all of them at
  once. 15 shared one identical mechanism: SQL Server's per-language
  label idiom `COALESCE(CASE WHEN STRPOS(Name,'{')>0 THEN <ParseJson
  chain> ELSE Name END, '')` mixes a `character varying` column (`Name`)
  with the `text`-typed `->>` chain the ParseJson rule (from two
  sessions ago) produces. PostgreSQL resolves that mixed COALESCE/CASE to
  `character varying` overall, but the result metadata correctly declares
  these columns `text` (the source SQL Server column is `nvarchar(max)`).
  Confirmed empirically against the live database with `pg_typeof`:
  unqualified the expression resolves to varchar (oid 1043); appending
  `::text` right after the outer `COALESCE` forces text (oid 25),
  matching the declared type.
- General fix: `CastJsonFallbackCoalesceToText` detects exactly this
  shape — an outer `COALESCE(` whose first branch is `CASE WHEN
  STRPOS(...)` and whose body contains the `::json->>` marker the
  ParseJson rule itself leaves behind — using the same
  `FindClosingParenthesis` balanced-paren helper as the other fixes, and
  appends `::text`. Because detection requires our own `::json->>`
  marker, it can only ever fire on constructs this converter itself
  produced; unrelated `COALESCE(CASE WHEN ...)` shapes are left alone.
- Result: 6 routines moved FAIL → PASS (the
  `board_getlistboardcontent`/`board_gettreesubmenu`/widget family). The
  remaining ~9 of the original 15 in this shape are still blocked by the
  separate `boolean = integer` fix's downstream discovery (already
  documented, net-neutral entry above) or other unrelated issues in the
  same routine.
- Validation: build PASS with 0 warnings/errors; NUnit 105/105; Board QA
  24/24; full rollback-only runtime smoke 256/76/22.
- Remaining FAIL breakdown by SQLSTATE (76 total): `42883` (~30, mostly
  missing SQL-Server-side helper functions — a dependency gap), `42804`
  (~21, now dominated by genuine multi-branch polymorphic procedures like
  `contacts_getuserdata`), `42P01` missing relation (7), `23502` NOT NULL
  violation (5), `42601` dynamic SQL syntax (5), `42703` missing column
  (5), `42P19` (1), `22012` (1).
- Next: no further single clean converter-owned pattern identified in the
  remaining buckets without deeper per-routine investigation; `42883`'s
  missing-helper-function entries are dependency gaps (not converter
  bugs — the SQL Server side hasn't been converted/deployed for those
  helpers) and the remaining `42804` entries are the already-documented
  polymorphic-procedure limitation. A dependency/triage report is the
  more appropriate next artifact rather than further blind
  generalization attempts.

## 2026-07-03 - Boolean-parameter 0/1 literal comparisons (net-neutral, kept for correctness)

- Runtime before: 250 PASS / 82 FAIL / 22 BLOCKED (354 discovered).
- Runtime after: **250 PASS / 82 FAIL / 22 BLOCKED** (354 discovered) —
  aggregate unchanged, but see below.
- Zero regressions: every previously-PASS and previously-BLOCKED routine
  kept its exact status.
- Root cause: SQL Server bit parameters are routinely compared against
  the integer literals 0/1 (`@Flag = 1`). Once converted to a PostgreSQL
  boolean parameter, that comparison has no operator (`boolean =
  integer`) — the largest single operator-mismatch pattern (6 routines,
  the entire `board_getlistboardcontent` family).
- General fix: `NormalizeBooleanParameterComparisons` rewrites `name = 1`
  / `name = 0` to `TRUE`/`FALSE`, but only for parameters *we ourselves*
  declared boolean — read directly from the already-computed parameter
  list, never guessed from naming or context. A same-named but unrelated
  bare table column is left untouched.
- Result: the `boolean = integer` error is eliminated project-wide (6 →
  0). However, all 6 affected routines share a separate, already-known
  bug (`structure of query does not match function result type` — the
  `text`/`character varying` mismatch from the `ParseJson` → `->>`
  conversion, documented in the entry below) that was simply hidden
  behind this one, so the aggregate PASS/FAIL/BLOCKED counts did not
  move. Kept anyway: it is a verified, zero-regression correctness fix,
  and this phase's explicit priority is correctness over PASS count —
  reverting a correct fix because a *different*, already-tracked bug is
  still blocking the same routines would be exactly the kind of PASS-count
  gaming this phase forbids.
- Validation: build PASS with 0 warnings/errors; NUnit 103/103; Board QA
  24/24; full rollback-only runtime smoke 250/82/22.

## 2026-07-03 - Cast COUNT(...) to integer

- Runtime before: 242 PASS / 90 FAIL / 22 BLOCKED (354 discovered).
- Runtime after: **250 PASS / 82 FAIL / 22 BLOCKED** (354 discovered).
- Zero regressions of any kind: all 242 previously-PASS routines stayed
  PASS, all 22 BLOCKED routines stayed BLOCKED, 8 FAIL routines moved
  straight to PASS.
- Investigated SQLSTATE 42804 (`structure of query does not match function
  result type`, 31 of 90 FAILs) by querying live PostgreSQL error `Detail`
  directly (the runtime harness redacts it). Found it is not one root
  cause: some are the already-documented genuine multi-branch polymorphic
  procedures (not generalizable), some are `character varying`/`text`
  direction mismatches, and 6 were a single clean pattern —
  `Returned type bigint does not match expected type integer` — always at
  a column backed by `COUNT(*) OVER()` or a plain `COUNT(...)`.
  Confirmed against `contacts_gettrashuserlist`: SQL Server's `COUNT`
  always returns `int`, matching the result metadata's declared
  `integer` column; PostgreSQL's `COUNT` (aggregate or windowed) always
  returns `bigint`, so the converted body silently changed the value's
  width.
- General fix: `CastCountToInteger` wraps every `COUNT(...)` call —
  including any trailing `OVER(...)` clause — with an explicit
  `::integer` cast, using the existing `FindClosingParenthesis` helper
  for correct balanced-paren matching. Applied everywhere in the body,
  not just RETURN QUERY positions, since it mirrors SQL Server's real
  semantics unconditionally; `COUNT_BIG(...)` is excluded by construction.
  No procedure names hardcoded, no column-position correlation needed.
- Validation: build PASS with 0 warnings/errors; NUnit 101/101; Board QA
  24/24; full rollback-only runtime smoke 250/82/22.
- Remaining FAIL breakdown by SQLSTATE (82 total): `42883` (~36, split
  between missing SQL-Server-side helper functions — a dependency gap,
  not a converter bug — and a handful of `operator does not exist`
  cases), `42804` (~25, now dominated by the genuine multi-branch
  polymorphic procedures plus a few text/varchar direction mismatches),
  `42P01` missing relation (7), `23502` NOT NULL violation (5), `42601`
  dynamic SQL syntax (5), `42703` missing column (2), `42P19` (1),
  `22012` (1).
- Next: the remaining `42804` bucket is heterogeneous with no further
  single clean pattern found; the multi-branch polymorphic cases need
  per-routine design decisions (not a blanket rule) and are better suited
  to a triage/dependency writeup than further blind generalization.

## 2026-07-03 - Generalize ParseJson conversion

- Runtime before: 240 PASS / 93 FAIL / 21 BLOCKED (354 discovered).
- Runtime after: **242 PASS / 90 FAIL / 22 BLOCKED** (354 discovered).
- Zero PASS regressions: all 240 previously-PASS routines kept PASS. One
  routine (`board_gettreesubmenu_v2_json`) moved FAIL → BLOCKED; this is a
  runtime-harness classification artifact, not a correctness regression —
  see below.
- Root cause: the largest FAIL sub-bucket (28 of 93) was SQLSTATE 42883
  `function parsejson(...) does not exist`. The converter already had a
  rule translating SQL Server's `(SELECT StringValue FROM ParseJson(x)
  WHERE Name = 'literal')` idiom to `x::json->>'literal'`, but the regex
  only matched a bare unqualified argument and a quoted string-literal key.
  Real usage is far more varied: alias-qualified arguments (`B.Name`,
  `CG.GroupName`), an alias-qualified WHERE column (`B.NAME` vs `NAME`),
  and — most commonly — a parameter reference as the key (`WHERE
  Name=_langcode`) rather than a literal. Every unmatched shape fell
  through untouched, leaving a call to a nonexistent function at runtime.
- General fix: broadened the regex to accept a dotted argument reference,
  an optional alias before `NAME` in the WHERE clause, and either a
  literal or an identifier as the key. No procedure names hardcoded.
- Result: all 28 `parsejson(...) does not exist` failures cleared
  project-wide.
- Note on `board_gettreesubmenu_v2_json`: this routine has an unrelated
  pre-existing bug (a `RETURN QUERY ... INTO BL ...` construct — a
  `SELECT ... INTO` table-creation statement that appears to have been
  mislabeled as a result-returning statement during conversion) and was
  never going to pass. Before this fix, the runtime harness's SETOF-record
  shape-inference heuristic happened to succeed just enough to invoke it
  for real and observe the direct `parsejson` error (classified FAIL).
  After the fix removed that error, the same heuristic no longer succeeds
  for this specific multi-`RETURN QUERY` shape, so it now falls back to
  the opaque "cannot accept a set" BLOCKED classification instead. The
  function was non-functional in both runs — no PASS was lost. The
  `RETURN QUERY ... INTO` bug is a separate, unrelated converter defect
  worth its own investigation later.
- Validation: build PASS with 0 warnings/errors; NUnit 98/98; Board QA
  24/24; full rollback-only runtime smoke 242/90/22.
- Remaining FAIL breakdown by SQLSTATE: `42883` (29 — mostly missing
  helper functions and a handful of `operator does not exist` cases),
  `42804` (15), `42P01` (7), `23502` (5), `42601` (5), `42703` (2),
  `42P19` (1), `22012` (1).
- Next: within the remaining `42883` bucket, distinguish genuine SQL
  Server-side dependency helpers (e.g. `uf_contactsdetail`,
  `getchildgroup`, `organization_getdepartmentsbyuser` — not yet
  converted/deployed, a dependency gap, not a converter bug) from the
  `operator does not exist: character varying + character varying` cases
  (~6), which look like a converter gap where `+` string concatenation
  wasn't rewritten to `||` in some code shape.

## 2026-07-03 - #variable_conflict use_column for every RETURNS TABLE function

- Runtime before: 238 PASS / 95 FAIL / 21 BLOCKED (354 discovered).
- Runtime after: **240 PASS / 93 FAIL / 21 BLOCKED** (354 discovered).
- Zero regressions: diffed every routine by name against the prior run — all
  238 PASS and all 21 BLOCKED routines kept their exact status.
- Root-cause analysis of the 95 FAILs grouped by SQLSTATE found the single
  largest converter-owned bucket was `42702` ambiguous column reference (30
  routines, all Board/Contacts). Confirmed in every one of the 30 cases: the
  ambiguous unqualified column name exactly matched a column declared in
  that routine's own `RETURNS TABLE(...)`. PL/pgSQL implicitly creates a
  variable per `RETURNS TABLE` output column, visible for the rest of the
  function body, so any unqualified reference to a same-named real column in
  a joined query becomes ambiguous between the table column and the shadow
  variable.
- General fix: the `#variable_conflict use_column` pragma was already
  emitted for MS table-valued functions (`isTableValued`) but not for
  procedures, nor for functions whose `RETURNS TABLE` came from
  static/catalog/metadata column inference. Broadened the condition to any
  `RETURNS TABLE(...)` output — the converter never emits `RETURN NEXT`
  against these shadow variables, so preferring the real table column is
  always safe. No procedure names hardcoded.
- Result: SQLSTATE 42702 failures went from 30 to 0 project-wide. 2 routines
  (`board_getwidgetcarousel`, `contacts_gethistorylist`) resolved straight
  to PASS. The other 28 progressed past the ambiguity to their next
  pre-existing issue (missing `parsejson()`/helper functions, missing
  relations, or `structure of query does not match function result type` —
  a different bug class, tracked separately below).
- Validation: build PASS with 0 warnings/errors; NUnit 96/96; Board QA
  24/24; full rollback-only runtime smoke 240/93/21.
- Remaining FAIL breakdown by SQLSTATE: `42883` missing function/operator
  (57), `42804` type/structure mismatch (15), `42P01` missing relation (7),
  `23502` NOT NULL violation (5), `42601` dynamic SQL syntax (5), `42703`
  missing column (2), `42P19` (1), `22012` (1).
- Next: `42883` is now the largest bucket. It splits into three distinct
  causes needing separate treatment: missing `parsejson()` helper (~20,
  needs a real implemented helper or a dependency classification — never
  stubbed), missing SQL-Server-side helper functions/procedures not yet
  converted (dependency, not a converter bug), and `operator does not
  exist: character varying + character varying` (~6, likely a converter gap
  where `+` string concatenation wasn't rewritten to `||`).

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
