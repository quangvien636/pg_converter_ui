# Runtime 42702 ambiguity fix report

## Result

| Metric | Before (`2458028`) | After | Delta |
|---|---:|---:|---:|
| Runtime PASS | 62 | 66 | +4 |
| Runtime FAIL | 200 | 196 | -4 |
| Runtime BLOCKED | 89 | 89 | 0 |
| SQLSTATE `42702` | 160 | 156 | -4 |

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

## Implementation scope

The converter rule is intentionally restricted to these four names and their
known table/column mappings. A global replacement was rejected because the
remaining functions contain joins, DML target columns, temp tables, CTEs, and
local variables where alias selection requires statement-aware analysis.

Four regression cases cover the exact generated aliases and qualified columns.

## Remaining top failure groups

| SQLSTATE | Count |
|---|---:|
| `42702` | 156 |
| `42883` | 16 |
| `42P01` | 12 |
| `22P02` | 5 |
| `42601` | 3 |
