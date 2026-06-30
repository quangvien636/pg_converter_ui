# Remaining Board Blockers

**Investigated commit:** `46e4b93`  
**Evidence baseline:** latest Board QA, `150 PASS / 12 FAIL`  
**Scope:** first compile-blocking construct in every remaining failing `Board_%` procedure  
**Constraint:** no converter or generated SQL was modified during this investigation.

## Executive Summary

All 12 remaining procedures convert without a converter exception, but their generated PL/pgSQL fails PostgreSQL parsing or PL/pgSQL validation with SQLSTATE `42601`.

| Root-cause family | Procedures | Count | Maximum direct PASS gain |
|---|---:|---:|---:|
| Cursor lifecycle/FETCH translation | `Board_DownBoard`, `Board_DownFolder`, `Board_UpBoard`, `Board_UpFolder`, `Board_UpdateLevelRand` | 5 | +5 |
| Dynamic SQL result capture (`INSERT ... EXEC`) | `Board_GetAllBoardContentsByBoardList`, `Board_Mobile_Search`, `Board_Web_Search` | 3 | +3 |
| Comment-separated `ELSE` control flow | `Board_GetBoardContents`, `Board_GetBoardContents_BK20181227` | 2 | +2 |
| Three-argument T-SQL `CONVERT` | `Board_GetAllBoardContents` | 1 | +1 |
| `FOR XML PATH` / XML `.value()` aggregation | `Board_GetTreeSubMenu_V2_Json` | 1 | +1 |
| **Total** |  | **12** | **+12** |

The “maximum direct PASS gain” assumes each listed first blocker is the only blocker. Several large procedures contain additional unsupported constructs behind the first error; therefore the estimates are ceilings until each rank is rerun against PostgreSQL.

## Root Cause Matrix

| Procedure | First blocking feature | First failing stage | Root cause | Responsible converter component | Complexity | Estimated gain from fix | Risk |
|---|---|---|---|---|---:|---:|---|
| `Board_DownBoard` | Cursor / FETCH | `BodyConverter.ConvertCursors` | Cursor declaration becomes `FOR _rec IN ...`, but `_rec` is not declared as `record`; FETCH assignment is malformed as `tempno; WHILE := _rec.boardno LOOP`. PostgreSQL first rejects the loop variable. | `BodyConverter.ConvertCursors`; declaration collection in `Converter.ConvertProcedure` | 6/10 | +4 shared | Medium |
| `Board_DownFolder` | Cursor / FETCH | `BodyConverter.ConvertCursors` | Same standard cursor rewrite defect as `Board_DownBoard`; generated `_rec` loop and FETCH target assignment are structurally invalid. | `BodyConverter.ConvertCursors`; procedure declaration emission | 6/10 | +4 shared | Medium |
| `Board_UpBoard` | Cursor / FETCH | `BodyConverter.ConvertCursors` | Same standard cursor rewrite defect; undeclared `_rec` is the first compiler blocker, with malformed FETCH/WHILE output behind it. | `BodyConverter.ConvertCursors`; procedure declaration emission | 6/10 | +4 shared | Medium |
| `Board_UpFolder` | Cursor / FETCH | `BodyConverter.ConvertCursors` | Same standard cursor rewrite defect; loop variable and FETCH target mapping are incomplete. | `BodyConverter.ConvertCursors`; procedure declaration emission | 6/10 | +4 shared | Medium |
| `Board_UpdateLevelRand` | `CURSOR FAST_FORWARD`, OPEN/FETCH | `BodyConverter.ConvertCursors` pattern recognition | The cursor declaration contains `FAST_FORWARD` between `CURSOR` and `FOR`, so the declaration is not recognized. Raw cursor lifecycle statements survive, and `board_cursor` is not a declared PL/pgSQL variable. | `BodyConverter.ConvertCursors` cursor-declaration grammar | 5/10 | +1, or part of +5 cursor rank | Medium |
| `Board_GetAllBoardContentsByBoardList` | Dynamic SQL / `INSERT ... EXEC` | `BodyConverter.ConvertExec` after temp-table conversion | T-SQL result capture is split into `INSERT INTO SearchResult;` followed by `PERFORM query();`. The empty INSERT is invalid, and invoking the SQL text as a function is semantically wrong. It must become one parameterized dynamic statement that inserts the query result. | `BodyConverter.ConvertExec`, `ConvertBoardTempTables`, assignment/statement-boundary interaction | 5/10 | +3 shared | Medium |
| `Board_Mobile_Search` | Dynamic SQL / `INSERT ... EXEC` | `BodyConverter.ConvertExec` after temp-table conversion | Same result-capture split: generated `INSERT INTO SearchResult; PERFORM query();`. PostgreSQL first stops at the incomplete INSERT. | `BodyConverter.ConvertExec`, `ConvertBoardTempTables` | 5/10 | +3 shared | Medium |
| `Board_Web_Search` | Dynamic SQL / `INSERT ... EXEC` | `BodyConverter.ConvertExec` after control-flow conversion | Same incomplete result-capture output. Additional nested SearchType IF closure risks exist behind this first blocker. | `BodyConverter.ConvertExec`, `ConvertBoardTempTables`, then `ConvertControlFlow` for follow-on validation | 6/10 | +3 shared | Medium-high |
| `Board_GetBoardContents` | Comment-separated `ELSE` | `BodyConverter.ConvertControlFlow` | A comment between the true branch and `ELSE` causes the converter to emit `END IF;` before `ELSE`. PostgreSQL reports syntax near the resulting branch boundary before reaching the later dynamic `EXECUTE format(...)`. | `BodyConverter.ConvertControlFlow`, branch stack/comment handling | 3/10 | +2 shared | Low |
| `Board_GetBoardContents_BK20181227` | Comment-separated `ELSE` | `BodyConverter.ConvertControlFlow` | Same source shape and malformed `END IF; ... ELSE` output as `Board_GetBoardContents`. Dynamic SQL remains a likely follow-on blocker after this is fixed. | `BodyConverter.ConvertControlFlow` | 3/10 | +2 shared | Low |
| `Board_GetAllBoardContents` | Three-argument `CONVERT` | `Converter.ConvertBody` scalar-function mapping | Static CTE output retains `CONVERT(CHAR(16), BC.RegDate, 120)`. PostgreSQL parses `CONVERT` as a type conversion form and rejects the SQL Server style argument list at the comma. The procedure’s dynamic SQL is commented out and is not its first blocker. | `Converter.ConvertBody` function/type conversion rules | 3/10 | +1 | Low-medium |
| `Board_GetTreeSubMenu_V2_Json` | `FOR XML PATH`, `TYPE`, XML `.value()` and `STUFF` | Unsupported syntax detection / body conversion | SQL Server XML string aggregation survives in executable SQL: `FOR XML PATH(''), TYPE` followed by `.value(...)`. PostgreSQL rejects `XML`. A second `FOR XML PATH` block exists later in the same procedure. | Missing rule in `BodyConverter`/`Converter.ConvertBody`; XML aggregation conversion should be isolated from OPENXML shredding | 7/10 | +1 | High |

## Root-Cause Details

### A. Cursor translation

Four procedures use the standard cursor shape and reach the cursor converter, but the emitted loop is incomplete:

```sql
FOR _rec IN SELECT ...
LOOP
    tempno;
WHILE := _rec.boardno LOOP
```

The first compiler error is the undeclared/non-record `_rec`. Merely declaring `_rec record` will expose the malformed FETCH assignment and extra loop, so the complete rank must map FETCH targets and remove the generated pseudo-WHILE lifecycle.

`Board_UpdateLevelRand` is a separate parser variant. `CURSOR FAST_FORWARD FOR` is outside the current cursor declaration grammar, so OPEN/FETCH/CLOSE/DEALLOCATE survive.

### B. Dynamic SQL result capture

Three procedures contain the conceptual T-SQL operation:

```sql
INSERT INTO #SearchResult
EXEC sp_executesql @Query
```

The generated output separates this into two invalid operations:

```sql
INSERT INTO SearchResult;
PERFORM query();
```

or, in related variants:

```sql
INSERT INTO SearchResult;
EXECUTE format(query, ...);
```

The converter needs to preserve result capture as one PL/pgSQL dynamic command, likely `EXECUTE` of an `INSERT INTO ...` prefix plus the query text. Parameter ordering, quoting, and SQL-injection safety make this a medium-risk change.

### C. Comment-separated ELSE

The two BoardContents procedures contain an ELSE associated with an IF, but a line comment between branches causes the control-flow stack to close the IF early. This is lower risk than general dynamic SQL because it can be guarded by a narrow regression: comments may occur between the last statement in a true branch and its ELSE without forcing `END IF`.

Both procedures contain later dynamic SQL, so +2 is an optimistic direct gain. They must be redeployed after this change to discover the next blockers.

### D. Three-argument CONVERT

`Board_GetAllBoardContents` is often grouped with dynamic SQL because its source contains dynamic SQL text, but its executable first blocker is in the static CTE:

```sql
CONVERT(CHAR(16), BC.RegDate, 120)
```

This needs a style-aware mapping such as `to_char` for supported date styles. A broad deletion of the style argument would compile but could silently change formatting semantics.

### E. FOR XML PATH aggregation

`Board_GetTreeSubMenu_V2_Json` has advanced past its CTE blocker. Its current first error is SQL Server XML aggregation, not OPENXML document shredding. The procedure uses `STUFF((SELECT ... FOR XML PATH(''), TYPE).value(...), ...)` in more than one place.

The likely PostgreSQL mapping is an ordered `string_agg`, but this must preserve:

- delimiter removal performed by `STUFF`;
- ordering inside the correlated subquery;
- XML escaping/unescaping behavior of `TYPE.value`;
- null handling;
- PostgreSQL 9.3 compatibility.

## Priority Ranking

### Rank 1 — Complete cursor lifecycle translation

- Expected PASS increase: **up to +5**.
- Affected: `Board_DownBoard`, `Board_DownFolder`, `Board_UpBoard`, `Board_UpFolder`, `Board_UpdateLevelRand`.
- Risk: **Medium**.
- Complexity: **6/10**.
- Modules: `BodyConverter.ConvertCursors`, declaration emission in `Converter`.
- Required coverage: standard cursor, `FAST_FORWARD`, multiple FETCH targets, initial/subsequent FETCH, loop exit, CLOSE/DEALLOCATE removal.

### Rank 2 — Preserve dynamic SQL result capture

- Expected PASS increase: **up to +3**.
- Affected: `Board_GetAllBoardContentsByBoardList`, `Board_Mobile_Search`, `Board_Web_Search`.
- Risk: **Medium-high**.
- Complexity: **6/10**.
- Modules: `BodyConverter.ConvertExec`, `ConvertBoardTempTables`, statement-boundary logic.
- Required coverage: `INSERT INTO temp EXEC sp_executesql`, query variables, parameterized execution, and no standalone incomplete INSERT.

### Rank 3 — Keep comment-separated ELSE attached to its IF

- Expected immediate PASS increase: **0 to +2**; both may reveal later dynamic-SQL blockers.
- Affected: `Board_GetBoardContents`, `Board_GetBoardContents_BK20181227`.
- Risk: **Low**.
- Complexity: **3/10**.
- Modules: `BodyConverter.ConvertControlFlow`.
- Required coverage: comments before ELSE, nested IF/ELSE, comments containing keywords, and ordinary completed IF blocks.

### Rank 4 — Map style-aware three-argument CONVERT

- Expected PASS increase: **+1**.
- Affected: `Board_GetAllBoardContents`.
- Risk: **Low-medium**.
- Complexity: **3/10**.
- Modules: `Converter.ConvertBody`.
- Required coverage: `CONVERT(CHAR(n), datetime, 120)`, normal two-argument conversion, unsupported styles producing explicit TODO warnings.

### Rank 5 — Convert FOR XML PATH string aggregation

- Expected PASS increase: **+1**.
- Affected: `Board_GetTreeSubMenu_V2_Json`.
- Risk: **High**.
- Complexity: **7/10**.
- Modules: new focused XML aggregation phase in `BodyConverter` or a bounded rule in `Converter.ConvertBody`.
- Required coverage: correlated aggregation, ordering, delimiter stripping, nulls, escaping, and both FOR XML occurrences in the procedure.

## Recommended Execution Order

If ranking strictly by expected PASS gain, use Ranks 1–5 above. If optimizing for lowest regression risk per unit effort, do Rank 3, Rank 4, Rank 1, Rank 2, then Rank 5.

After every rank:

1. Build.
2. Run NUnit.
3. Run the Board QA runner and inspect the new first error for every affected procedure.
4. Run `scratch/run_post_commit_qa.ps1`.
5. Recalculate expected gains; do not assume a procedure has only one blocker.

## Evidence and Confidence

- High confidence: current PostgreSQL error text, surviving generated constructs, and exact malformed cursor/XML/control-flow output.
- Medium confidence: dynamic-SQL first-blocker ordering where the QA report records only the error token, not PostgreSQL statement position.
- The stale `scratch/board_fails.json` was not used.
- Generated SQL was inspected only and was not edited.
