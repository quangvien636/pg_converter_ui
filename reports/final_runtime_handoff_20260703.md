# Final runtime converter handoff

Generated: 2026-07-03  
Baseline commit: `ec3a9eb`  
Final converter commit: `6a740b5`

## Final verification

| Gate | Result |
|---|---:|
| Product build | PASS, 0 warnings/errors |
| NUnit regression | 81/81 PASS |
| Board representative QA | 24/24 PASS |
| Runtime PASS | 229 |
| Runtime FAIL | 20 |
| Runtime BLOCKED | 105 |
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

Net improvement since `ec3a9eb`: **+2 runtime PASS and -8 runtime FAIL**.

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

## Runtime progression

| Stage | PASS | FAIL | BLOCKED |
|---|---:|---:|---:|
| `ec3a9eb` baseline | 227 | 28 | 99 |
| Integer `SUBSTRING` coercion | 227 | 23 | 104 |
| Optional `INSERT INTO` | 227 | 22 | 105 |
| Exact temp-table return metadata | 228 | 22 | 104 |
| Temp-table numeric typing | **229** | **20** | **105** |

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
