# Runtime 42702 ambiguity fix report

## Result

| Metric | Before (`2458028`) | After | Delta |
|---|---:|---:|---:|
| Runtime PASS | 62 | 82 | +20 |
| Runtime FAIL | 200 | 180 | -20 |
| Runtime BLOCKED | 89 | 89 | 0 |
| SQLSTATE `42702` | 160 | 140 | -20 |

Every invocation ran on `pg_converter_runtime_test` under the runner's outer
transaction and final `ROLLBACK`. Runtime PASS establishes execution only, not
business equivalence.

## Classification of the original 160 failures

Declaration-origin classification from deployed function definitions:

| Ambiguity type | Count | Notes |
|---|---:|---|
| Parameter name vs column name | 143 | The ambiguous identifier is an input parameter and a visible bare column. |
| PL/pgSQL variable vs column name | 17 | The identifier is declared in the PL/pgSQL `DECLARE` block and also used as a column. |
| Output column vs source column | 0 independently identified | Some RETURN QUERY cases may overlap parameter collisions; no first error uniquely proved this class. |
| Temp-table column vs variable | 0 independently identified | Their first reported errors mapped to a declared parameter or variable. |
| CTE column vs function parameter | 0 independently identified | No first error was uniquely attributable to a CTE. |

Statement-location classification (overlaps the declaration-origin categories):

| Location | Count |
|---|---:|
| Unqualified `SELECT` / `RETURN QUERY` | 61 |
| Unqualified SQL statement (`UPDATE`, `DELETE`, or non-returning `SELECT`) | 86 |
| Other PL/pgSQL context | 13 |

## Root cause fixed

Four single-table aggregate functions already qualified the intended parameter
as `function_name.parameter`, but left the matching table column bare:

```sql
FROM Board_Folders
WHERE FolderNo = board_board_maxsortno_select.folderno
```

The scoped fix adds an alias and qualifies only the confirmed table column:

```sql
FROM Board_Folders bf
WHERE bf.FolderNo = board_board_maxsortno_select.folderno
```

This preserves the comparison, filter, aggregate, and outward result shape.

## Procedures moved to runtime PASS

- `board_board_maxsortno_select`
- `board_countboardinfolder`
- `board_countcontentinboard`
- `board_folder_maxsortno_select`
- `contacts_countgroupuser`
- `contacts_getalladdress`
- `contacts_getallcompany`
- `contacts_getalldays`
- `contacts_getallemail`
- `contacts_getallgroupuser`
- `contacts_getallhomepage`
- `contacts_getallnumber`
- `contacts_getallsns`
- `contacts_getalluser`
- `contacts_getallusernotrequite`
- `contacts_getcheckgroup`
- `contacts_getcontactsgroup`
- `contacts_getlocationonecontact`
- `contacts_gettrashcount`
- `contacts_parentgroupno`

## Contact getter batch

Sixteen confirmed getters read one Contact table and compared a bare source
column such as `RegUserNo` with an already qualified function parameter. Each
mapping adds a procedure-specific table alias and qualifies only the colliding
source columns.

`contacts_getlocationonecontact` exposed the output/source subtype after its
WHERE clause was fixed: `RegUserNo` and `ContactUserId` also appeared bare in
the SELECT projection. Its known projection is qualified with the same alias;
outward column names and order are unchanged.

## Implementation scope

The converter rule is intentionally restricted to these four names and their
known table/column mappings. A global replacement was rejected because the
remaining functions contain joins, DML target columns, temp tables, CTEs, and
local variables where alias selection requires statement-aware analysis.

Four regression cases cover the exact generated aliases and qualified columns.

## Remaining top failure groups

| SQLSTATE | Count |
|---|---:|
| `42702` | 140 |
| `42883` | 16 |
| `42P01` | 12 |
| `22P02` | 5 |
| `42601` | 3 |
