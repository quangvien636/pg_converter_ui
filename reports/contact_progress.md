# Contact module progress

**Date:** 2026-06-30  
**Source:** `CrewCloud_Company_Bootstrap`  
**Target:** `pg_converter_runtime_test`  
**Naming scope:** both `Contact_` and `Contacts_`

## Source inventory

| SQL Server object type | Count |
|---|---:|
| Stored procedures (`P`) | 189 |
| Table-valued functions (`TF`) | 2 |
| Tables (`U`) | 8 |
| **Total source objects** | **199** |

Procedure prefixes:

- `Contact_`: 3 procedures
- `Contacts_`: 186 procedures

Non-procedure objects:

- Functions: `Contacts_GetChildGroupByGroupNo`, `Contacts_StringToListInt`
- Tables: `Contact_DepartAllowAccess`, `Contact_PublicGroup`,
  `Contact_PublicGroupUser`, `Contact_ShareGroup`, `Contact_ShareGroupUser`,
  `Contacts_ListGroup`, `Contacts_ListGroupContact`, `Contacts_Locations`

The current Contact validation runner covers all 189 stored procedures. It does
not compile/deploy the two table-valued functions or eight tables; they are not
reported as PASS.

## Procedure compile summary

| Metric | Baseline | Current | Delta |
|---|---:|---:|---:|
| Total procedures | 189 | 189 | 0 |
| Conversion PASS | 189 | 189 | 0 |
| Compile PASS | 123 | 175 | **+52** |
| Compile FAIL | 66 | 14 | **-52** |
| Compile rate | 65% | 92% | +27 points |

Current validation gates:

- Release build: PASS
- Regression: 46/46 PASS
- Board representative QA: 24/24 PASS
- Board compile: 162/162 PASS
- Contact procedure compile: 175/189 PASS

The complete procedure inventory and per-object result are in
`reports/Contact_Procedure_Validation.md`.

## Iterations

| Iteration | PASS | FAIL | PASS gain | Main fixes |
|---|---:|---:|---:|---|
| Baseline | 123 | 66 | 0 | Current Board-complete converter |
| 1 | 152 | 37 | +29 | Contact block balancing, numeric empty defaults, OUTPUT + SETOF signature |
| 2 | 164 | 25 | +12 | TOP/assignment ordering, string accumulation, EXEC with literal arguments |
| 3 | 171 | 18 | +7 | Header parsing, CTE-to-DML boundary, inline comments, string concatenation |
| 4 | 173 | 16 | +2 | Late RETURN QUERY normalization, schema-qualified EXEC, `@ERROR` |
| 5 | 175 | 14 | +2 | Multiline DECLARE, comma CHARINDEX, two-argument CONVERT |
| 6 | 175 | 14 | 0 | BEGIN with trailing comment; regression covered but no compile gain |

## Fixed root-cause groups

- Invalid numeric parameter default `''` now maps to `NULL`.
- `INOUT` is demoted to `IN` when a procedure also becomes `SETOF`; a warning
  records the lost SQL Server OUTPUT channel.
- Contact control-flow receives the proven block/statement normalization used
  by Board.
- `TOP` is removed before `SELECT @var = ...` conversion.
- `SET @var += ...` becomes null-safe PL/pgSQL string accumulation.
- Procedure calls with literal arguments and schema-qualified names become
  `PERFORM`.
- Procedure header parsing supports comments, multiline parameter lists and
  inline `AS`.
- Unparenthesized parameter lists ending in a sized type no longer lose their
  final type parenthesis.
- CTE definitions remain attached to their following DML statement.
- Multiple result sets receive `RETURN QUERY` before statement-boundary repair.
- Multiline `DECLARE` blocks are collected into PL/pgSQL declarations.
- `CHARINDEX(',', value)` and two-argument `CONVERT(VARCHAR(n), value)` are
  converted without comma/parser corruption.

## Remaining 14 procedure failures

All remaining errors are PostgreSQL `42601`:

- `Contacts_DelContactsGroup`
- `Contacts_DeleteAddressAll`
- `Contacts_DeleteDepartAllowAccess`
- `Contacts_GetContactsCount`
- `Contacts_GetContactsList`
- `Contacts_GetContactsTrashList`
- `Contacts_SaveAddressInfo`
- `Contacts_SaveAddressInfo_Web`
- `Contacts_SaveArrange`
- `Contacts_SaveArrangeLike`
- `Contacts_SaveContactsForOutlook`
- `Contacts_SaveRestore`
- `Contacts_UpdateDepartAllowAccess`
- `Contacts_UpdateUserInfo`

Root-cause groups:

| Group | Objects | Risk / required work |
|---|---:|---|
| Deep nested IF/ELSE/WHILE blocks mixed with comments and plain BEGIN/END | 7 | Requires a structured block parser; further regex changes risk Board regression |
| Dynamic SQL with multiline parameter declarations and named bindings | 2 | Requires parsing `sp_executesql` parameter metadata and binding lists |
| Temp-table / recursive CTE materialization | 3 | Requires statement-level parsing to distinguish source table, destination temp table and CTE scope |
| TRY/CATCH plus transaction and result-select semantics | 1 | Requires explicit PL/pgSQL exception-block design |
| Very large branching result query | 1 | Requires exact PostgreSQL error-position capture and statement AST/boundary analysis |

## Next priorities

1. Extend the validation runner to deploy the eight Contact tables and compile
   the two table-valued functions, so all 199 source objects are covered.
2. Add PostgreSQL error position and failed statement excerpts to the runner.
3. Implement a token/stack-based T-SQL block parser for the seven deeply nested
   procedures instead of adding more global regexes.
4. Add a dedicated `sp_executesql` parser for multiline parameter definitions.
5. Model temp-table/CTE statements before attempting the remaining three
   materialization failures.

## Stop reason

The session stops at the architecture-decision condition, not at 100%:

- 175/189 procedures compile.
- 14 complex procedures still fail and are not ignored.
- 10 non-procedure Contact objects need an expanded deployment harness and are
  not claimed as PASS.
- Board remains 162/162 compile PASS.

Continuing with broad regex substitutions would create a material regression
risk for Board and already-passing Contact procedures. The next step should be
approved as a scoped parser/runner expansion.
