# Final runtime converter handoff

Generated: 2026-07-03  
Baseline commit: `ec3a9eb`  
Security cleanup commit: `423dee0`  
Final converter commit: `615b6ad`

## Final verification

| Gate | Result |
|---|---:|
| Product build | PASS, 0 warnings/errors |
| NUnit regression | **108/108 PASS** |
| Board representative QA | **24/24 PASS** |
| Runtime PASS | **260** |
| Runtime FAIL | **72** |
| Runtime BLOCKED | **22** |
| Total routines | 354 |

Runtime validation used catalog discovery, typed dummy inputs, and a transaction
that was rolled back after execution. A PASS proves the invocation executed; it
does not by itself prove business equivalence.

## Commits since `ec3a9eb`

| Commit | Change | Runtime after |
|---|---|---:|
| `51e3410` | Preserve integer `SUBSTRING` coercion | 227 PASS / 23 FAIL / 104 BLOCKED |
| `5a46ff3` | Handle boolean INSERTs without `INTO` | 227 PASS / 22 FAIL / 105 BLOCKED |
| `de6d74c` | Infer exact temp-table result metadata | 228 PASS / 22 FAIL / 104 BLOCKED |
| `6a740b5` | Type numeric temp-table INSERTs | 229 PASS / 20 FAIL / 105 BLOCKED |
| `9335dd1` | Quote reserved words; reject duplicate result columns | 229 PASS / 20 FAIL / 105 BLOCKED |
| `e3d2312` | Document SQL Server result metadata improvement | 229 PASS / 20 FAIL / 105 BLOCKED |
| `f9b7863` | Emit `#variable_conflict use_column` for every RETURNS TABLE | 240 PASS / 93 FAIL / 21 BLOCKED |
| `c9b282a` | Document `#variable_conflict` improvement | 240 PASS / 93 FAIL / 21 BLOCKED |
| `0dd77bd` | Generalize ParseJson conversion | 242 PASS / 90 FAIL / 22 BLOCKED |
| `c4b6ec5` | Document ParseJson improvement | 242 PASS / 90 FAIL / 22 BLOCKED |
| `6c86a69` | Cast `COUNT(...)` to integer | 250 PASS / 82 FAIL / 22 BLOCKED |
| `1c60e92` | Document COUNT cast improvement | 250 PASS / 82 FAIL / 22 BLOCKED |
| `fe2acab` | Rewrite boolean-parameter 0/1 comparisons to TRUE/FALSE | 250 PASS / 82 FAIL / 22 BLOCKED |
| `f701d9e` | Document boolean-parameter fix | 250 PASS / 82 FAIL / 22 BLOCKED |
| `d701ede` | Cast ParseJson fallback COALESCE to text | 256 PASS / 76 FAIL / 22 BLOCKED |
| `05dcd0d` | Document COALESCE text-cast improvement | 256 PASS / 76 FAIL / 22 BLOCKED |
| `5e00144` | WITH RECURSIVE for self-referencing CTEs | 260 PASS / 72 FAIL / 22 BLOCKED |
| `2542e81` | Document WITH RECURSIVE + hang fix | 260 PASS / 72 FAIL / 22 BLOCKED |
| `615b6ad` | Add FAIL triage report and session summary | 260 PASS / 72 FAIL / 22 BLOCKED |

Net improvement since `ec3a9eb`: **+31 runtime PASS, −23 runtime FAIL**.

## General converter rules added

1. Preserve SQL Server empty-string-to-zero behavior when a `SUBSTRING`
   expression is assigned to a declared integer local. Text targets are
   unchanged.
2. Recognize both SQL Server boolean INSERT forms: `INSERT INTO Table` and
   `INSERT Table`.
3. Infer `RETURNS TABLE` only when the final result is exactly `SELECT *` from
   a locally declared temp table and every output name/type is explicit and
   recognized.
4. Parse local temp-table schemas and coerce proven text sources into numeric
   columns during INSERT, without affecting permanent tables or unknown
   expressions.
5. Emit `#variable_conflict use_column` for every function with a
   `RETURNS TABLE(...)` output, eliminating all 30 `42702` ambiguous-column
   failures project-wide.
6. Generalize ParseJson conversion to accept dotted argument references,
   optional alias qualifiers, and parameter-key (identifier) WHERE clauses —
   eliminating all 28 `42883 parsejson(...) does not exist` failures.
7. Cast every `COUNT(...)` (aggregate and windowed) to `::integer` to match
   SQL Server's guaranteed `int` return width.
8. Rewrite boolean-parameter `name = 1`/`name = 0` comparisons to `TRUE`/`FALSE`
   using the already-computed parameter list — zero new false positives.
9. Cast the ParseJson per-language fallback `COALESCE(CASE WHEN STRPOS(...)...)`
   to `::text`, matching the declared result type from SQL Server metadata.
10. Replace the broken pre-existing WITH RECURSIVE detection with
    `AddRecursiveToSelfReferencingCte`, which uses balanced-paren walking per
    CTE entry and `SkipCommentsAndWhitespace` to avoid catastrophic backtracking.

## Runtime progression

| Stage | PASS | FAIL | BLOCKED |
|---|---:|---:|---:|
| `ec3a9eb` baseline | 227 | 28 | 99 |
| Integer `SUBSTRING` coercion | 227 | 23 | 104 |
| Optional `INSERT INTO` | 227 | 22 | 105 |
| Exact temp-table return metadata | 228 | 22 | 104 |
| Temp-table numeric typing | 229 | 20 | 105 |
| SQL Server result metadata integration | 238 | 95 | 21 |
| `#variable_conflict use_column` for all RETURNS TABLE | 240 | 93 | 21 |
| Generalize ParseJson conversion | 242 | 90 | 22 |
| Cast `COUNT(...)` to integer | 250 | 82 | 22 |
| Boolean-parameter 0/1 comparisons | 250 | 82 | 22 |
| ParseJson COALESCE text cast | 256 | 76 | 22 |
| WITH RECURSIVE for self-referencing CTEs | **260** | **72** | **22** |

## Remaining FAIL groups

### NOT NULL or seed-data constraints — 5

- `contact_insertsharegroup`: `moduserno` is NULL.
- `contacts_getgroupbyuser`
- `contacts_insertgroup`
- `contacts_insertpublicgroup`
- `contacts_insertsharegroup`: `sort` is NULL.

These require valid seed data, confirmed defaults, or reviewed source behavior.

### Dynamic/generated SQL — 5

- `board_getboardcontents`
- `board_getboardcontents_bk20181227`: malformed multiline dynamic SQL in the
  committed conversion; the complete binding experiment later reached a
  missing `organization_getdepartmentsbyuser(integer)` helper.
- `board_mobile_search`: generated SQL syntax near `DESC`.
- `board_insertnotificationservice`
- `board_updatenotificationservice`: XML shredding leaves a destinationless
  placeholder SELECT.

### Missing helpers or incompatible signatures — 5

- `board_gettreesubmenu_v2_json`: missing `parsejson(varchar)`.
- `contacts_insertuserforexcel`: incompatible
  `contacts_insertlistgroupcontact(integer, varchar)` invocation.
- `board_setshare` and `contacts_setshare`: text/integer mismatch; a safe cast
  then exposes missing `comngetdepartname(integer)`.
- `contacts_setcontactsrestore`: integer/varchar mismatch.

### Missing columns — 2

- `contacts_getcontactscount`
- `contacts_getcontactslist`: generated dynamic SQL references
  `p_reguserno` without deployed parameter binding.

### Source-specific runtime errors — 2

- `board_getallboardcontentsbyboardlist`: division by zero with dummy input.
- `contacts_saveaddressinfo`: SQL Server source itself inserts `@UserNo` into
  the `ModDate` column; changing it requires a business/source correction.

### Missing relation — 1

- `contacts_updateandroiddevice_notificationoptions` references
  `_AndroidDevices`, but no matching source table object was found.

## BLOCKED routines

All **105 BLOCKED** routines return `SETOF record` without inferable OUT
metadata. This PostgreSQL server rejects invoking those set-returning functions
in scalar context. They remain BLOCKED because inventing output names or types
would create false runtime PASS results.

## Attempted and rolled back

- Catalog-backed `SELECT *` return inference was rejected after three routines
  moved BLOCKED to FAIL (`228/25/101`). Exact table metadata did not prove that
  converted query row contracts were valid.
- Multiline dynamic-string preservation removed the embedded semicolon but
  exposed `BoardNo` ambiguity without changing aggregate status.
- Declared `sp_executesql` `$n`/`USING` binding resolved parsing and ambiguity,
  then exposed the non-deployable
  `organization_getdepartmentsbyuser(integer)` dependency. It was rolled back
  because runtime status did not improve.
- Text-parameter/integer comparison coercion resolved two type errors, then
  exposed missing `comngetdepartname(integer)`. It was rolled back because the
  helper could not be deployed and status did not improve.
- Empty XML temp-table stubs were not used: they would silently discard alarm
  detail data and manufacture PASS.
- `_AndroidDevices` generation was rejected because no authoritative source
  schema exists.

## Exact next requirements

1. **SQL Server result metadata for SETOF record routines** — reviewed output
   column names, order, and SQL types for each result path.
2. **Real helper function deployment/signature mapping** — especially
   `Organization_GetDepartmentsByUser`, `ComnGetDepartName`, `ParseJson`, and
   `Contacts_InsertListGroupContact`.
3. **Safe dynamic SQL parameter binding** — static resolution of parameter
   metadata variables and declaration-order PostgreSQL `EXECUTE ... USING`,
   validated together with all called helpers.
4. **Source relation/table-variable generation** — authoritative schemas for
   missing relations such as `_AndroidDevices`; do not synthesize them from
   usage alone.

No credentials or scratch scripts are part of the handoff commit.
