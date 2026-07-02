# Claude pgsql-fix applicability review

Reviewed source: Claude command/skill document `pgsql-fix` (843 lines).
The document was treated as a knowledge source, not an executable workflow: its
instructions that commit database changes or target other databases are explicitly
inapplicable because this project permits only rollback-only execution on
`pg_converter_runtime_test`.

## Runtime evidence reviewed

- Baseline commit `32d24b6`: 24 PASS / 144 FAIL / 183 BLOCKED.
- Current run after SETOF inference and the confirmed LEN expansion:
  56 PASS / 202 FAIL / 93 BLOCKED.
- The apparent FAIL increase is expected: 90 formerly blocked routines now reached
  embedded SQL and exposed real runtime errors.
- Current leading failures: 160 `42702`, 19 `42883`, 12 `42P01`.

## Rule classification

| Rule from pgsql-fix | Classification | Evidence / decision |
|---|---|---|
| Compile validation must be followed by test invocation | Already implemented | Runtime runner records actual invocation and PostgreSQL context. |
| `SETOF record` needs a reviewed column definition | Useful for current runtime failures | Metadata-only inspection inferred 95 shapes; conflicting/unresolvable shapes remain blocked. |
| Convert fixed results to `RETURNS TABLE` | Risky / needs manual review | Changes public signatures and caller-visible column casing; runner uses call-site definitions instead. |
| Parameter local copy plus table alias/column qualification | Useful for current runtime failures | 160 confirmed `42702`; broad regex would be unsafe because both halves are required. |
| `LEN` to `LENGTH` | Already implemented / current expansion | Four procedures passed after commit `32d24b6`; three newly exposed procedures have the same `42883`. |
| `CHARINDEX` argument reversal | Already implemented | Existing regression covers comma literal. |
| ParseJson to native JSON extraction | Useful for current runtime failures | Project context has a reproduced gap; apply only to matching observed calls. |
| Split helper to `string_to_array` | Useful for current runtime failures | Multiple current `42883`; return shape and integer-error semantics need verification first. |
| Cursor to `FOR ... LOOP` | Risky / needs manual review | Converter support exists; ordering and side effects still need runtime fixtures. |
| Temp tables to CTE/loop | Risky / needs manual review | Strategy is procedure-specific and can change repeated-invocation semantics. |
| Dynamic SQL to `EXECUTE`/`format` | Useful for current runtime failures | Confirmed quote errors exist; must preserve bindings and NULL semantics. |
| XML aggregation to array/string aggregation | Already implemented | Board compile/runtime work already has targeted handling. |
| Identity via `RETURNING`, never `MAX(id)` + `setval` | Useful later | No current failure selected for this iteration. |
| Recursive CTE and DML `USING` | Useful later | Requires business fixtures for tree semantics. |
| BIT comparisons only after checking real type | Already implemented / manual review | Avoid converting integer flags. |
| Stub complex procedures | Not applicable | Current objective is runtime validation; stubbing would create false success. |
| Commit/execute workflow from the Claude tool | Not applicable | Conflicts with mandatory final ROLLBACK and database restriction. |
| Large parser refactor | Risky / needs manual review | No parser work without a specific runtime counterexample. |

## Selected changes for this iteration

1. SETOF record call-site shape inference, because it directly targets 183 blocked
   routines and does not change deployed signatures. Result: BLOCKED reduced by 90.
2. Extend the already-confirmed `LEN` fix to the newly executed routines
   `contacts_savearrange`, `contacts_savearrangelike`, and
   `contacts_saverestore`. Result: all three moved from FAIL to PASS.

The 160 ambiguity failures are higher impact but deliberately deferred from automatic
conversion: `pgsql-fix` itself documents that qualifying only the parameter side is
insufficient, and safely aliasing every affected table requires statement-aware work.
