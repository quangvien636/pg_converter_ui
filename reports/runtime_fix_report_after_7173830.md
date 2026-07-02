# Runtime fix report after 7173830

## Baseline and result

| Metric | Commit 7173830 baseline | Current | Delta |
|---|---:|---:|---:|
| Runtime PASS | 56 | 62 | +6 |
| Runtime FAIL | 202 | 200 | -2 |
| Runtime BLOCKED | 93 | 89 | -4 |
| Total | 351 | 351 | 0 |

Runtime PASS means only that the recorded invocation executed inside the
rollback-only smoke transaction. It does not establish SQL Server behavioural
equivalence.

## Root causes fixed

1. `TINYINT` survived inside generated temporary-table DDL even though header
   types were already mapped. `Converter.ConvertBody` now maps it to `smallint`.
2. The two affected functions then exposed the already-confirmed `LEN` runtime
   failure; their rollback-only deployed definitions use the converter's
   `LENGTH` mapping.
3. SETOF shape inference rejected bare parameters even for `SELECT` expressions
   with no `FROM`. In that restricted context a bare input name cannot be a table
   column, so typed substitution is safe for metadata discovery. Queries with a
   `FROM` clause retain the conservative behaviour.

## Procedures moved to runtime PASS

- `contacts_saveaddressinfo_web`
- `contacts_updateuserinfo`
- `contacts_deletepublicgroup`
- `contacts_deletesharegroup`
- `contacts_updatepublicgroup`
- `contacts_updatesharegroup`

The first two validate the converter/runtime fixes. The remaining four were
unblocked by the safe no-FROM SETOF inference improvement.

## Remaining leading failure groups

| SQLSTATE | Count | Current handling |
|---|---:|---|
| `42702` ambiguous parameter/column | 160 | Requires local parameter copies plus table alias/column qualification; no broad regex fix. |
| `42883` missing function/operator | 16 | Split helpers, `NVARCHAR`, `YEAR`, missing calls and type mismatches need separate evidence-backed fixes. |
| `42P01` missing relation | 12 | Source-owned versus external dependency classification required. |
| `22P02` invalid integer input | 5 | Requires source-valid fixtures before declaring converter defects. |
| `42601` runtime syntax/result handling | 3 | Procedure-specific analysis. |
