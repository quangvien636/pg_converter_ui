# Runtime FAIL triage — 2026-07-03

## Session result

| Status | Session start | Session end |
|---|---:|---:|
| Runtime PASS | 238 | **260** |
| Runtime FAIL | 95 | **72** |
| Blocked | 21 | **22** |
| Total discovered | 354 | 354 |

Six generalized converter fixes landed this session, each verified against the live
runtime database with a before/after diff of every routine by name (zero PASS
regressions in every step):

1. `#variable_conflict use_column` for every `RETURNS TABLE(...)` function — SQLSTATE
   42702 ambiguous-column eliminated (30 → 0).
2. Generalized `ParseJson` → `->>` conversion to parameter keys and qualified column
   references — `parsejson(...) does not exist` eliminated (28 → 0).
3. Cast `COUNT(...)` (aggregate or windowed) to `integer`, matching SQL Server's
   return width instead of PostgreSQL's `bigint`.
4. Rewrite boolean-parameter `= 0` / `= 1` literal comparisons to `TRUE`/`FALSE` for
   parameters the converter itself declared `boolean`.
5. Cast the `ParseJson` per-language-fallback `COALESCE` to `text`, matching the
   metadata-declared type instead of PostgreSQL's default `character varying`
   resolution.
6. Emit `WITH RECURSIVE` for self-referencing CTEs — fixed a pre-existing, broken
   attempt at this same rule, and fixed a catastrophic-backtracking hang discovered
   in the first version of the replacement.

Full details, root-cause evidence, and validation numbers for each are in
`walkthrough.md`.

## Remaining 72 FAILs by SQLSTATE

| SQLSTATE | Count | Category |
|---|---:|---|
| 42883 (undefined function/operator) | 31 | Mostly dependency; some one-off operator gaps |
| 42804 (datatype mismatch) | 22 | Mostly structural (polymorphic procedures) |
| 23502 (NOT NULL violation) | 5 | One real semantic gap, needs careful fix |
| 42601 (syntax error / no destination) | 5 | Dynamic SQL — out of scope this phase |
| 42703 (undefined column) | 5 | Mixed, mostly one-offs |
| 42P19 (recursive CTE type mismatch) | 2 | Newly exposed by the WITH RECURSIVE fix |
| 42P01 (undefined relation) | 1 | One-off, different cause from the CTE fixes |
| 22012 (division by zero) | 1 | Likely dummy-data artifact |

## Why no further blanket fix was attempted

### 42883 — undefined function/operator (31)

Breaks down into two very different kinds of problem:

- **Missing helper functions/procedures** (`uf_contactsdetail`, `uf_contactsdetailexcel`,
  `fn_getchilddepartnobydepartno`, `getchildgroup`, `organization_getdepartmentsbyuser`,
  `uf_departmentname`, `uf_regularextext`, `contacts_insertlistgroupcontact` — roughly
  half this bucket). These are genuine **dependencies**: SQL-Server-side helper
  routines that exist in the source but have not themselves been converted/deployed
  into `pg_converter_runtime_test`. This is not a converter bug — the fix is to
  convert and deploy those specific helpers, which is a data/scope question, not a
  code-generation rule.
- **Operator-mismatch one-offs** (`character varying + character varying` (6),
  `integer = character varying` (3), `character varying = integer` (2),
  `character = boolean` (2), `~ boolean` (2), `text = integer` (1), `text + text` (1),
  `boolean =~ boolean` (1)). The `+` concatenation cases are real (SQL Server allows
  `+` for both arithmetic and string concatenation depending on operand type, and the
  existing regex rules only convert `+` to `||` when at least one side is a string
  literal or an explicit `CAST(...AS text/varchar)` — a bare `col1 + col2` between two
  unknown-to-the-converter columns is correctly left alone rather than guessed). A
  trustworthy general fix here would need the converter to know each column's actual
  type — i.e. threading the `tableCatalog`/result-metadata catalog into alias-to-table
  resolution inside `ConvertProcedure` (it currently isn't passed at all; only
  `ConvertFunction` receives it) so `+` between two confirmed-string columns can be
  safely rewritten to `||`. That is a legitimate next converter feature, but it is a
  new capability (FROM-clause alias resolution), not a one-line rule, and each
  remaining operator-mismatch flavor here is 1-6 occurrences — below the bar for this
  phase's "ignore isolated one-off procedures" guidance.

### 42804 — datatype mismatch (22)

The bulk of this bucket is the already-documented **structural limitation**: SQL
Server procedures like `Contacts_GetUserData` branch on a parameter and return a
genuinely different column shape per branch (confirmed via `OBJECT_DEFINITION` —
15+ `IF @Key = '...'` branches, each with its own `SELECT`). No SQL Server
schema-description API (including the FMTONLY fallback built for this project) can
capture more than one representative shape, so any single `RETURNS TABLE` is only
correct for some branches. This is not fixable by better metadata or a converter
rule — it needs a per-routine design decision (e.g. splitting into multiple
single-shape functions, or deliberately keeping `SETOF record` with caller-supplied
column types). That is inherently one-off, per-routine work, explicitly out of scope
for "smallest generalized rule."

### 23502 — NOT NULL violation (5)

Four of five share one real, well-known SQL-Server-to-PostgreSQL semantic gap,
confirmed against `Contacts_InsertGroup`'s source:

```sql
DECLARE @Sort INT = 1, @GroupNo INT
SELECT TOP 1 @Sort = Sort FROM ContactsGroup WHERE ... ORDER BY Sort DESC
INSERT INTO ContactsGroup (..., Sort, ...) VALUES (..., @Sort+1, ...)
```

SQL Server's `SELECT @var = expr FROM ...` **leaves `@var` unchanged** when zero rows
match. PostgreSQL's `SELECT expr INTO var FROM ...` **always sets `var` to NULL**
when zero rows match, even if `var` already held a value. For a brand-new top-level
group (the common case — no existing siblings), `_sort` becomes `NULL` instead of
staying `1`, and `NULL + 1` is `NULL`, which then violates the `sort` column's
NOT NULL constraint.

This is genuinely generalizable in principle (preserve the prior value when the
`SELECT ... INTO` finds no row), but a *safe* general fix requires the converter to
track each variable's original `DECLARE ... = <default>` value (currently parsed and
discarded) and emit `IF NOT FOUND THEN var := <default>; END IF;` after the matching
`SELECT INTO`. Implementing that plumbing correctly — for both single- and
multi-variable `SELECT @a = x, @b = y FROM ...` assignments — is a meaningfully larger
change than this session's other fixes for only 4 confirmed occurrences, and a wrong
implementation would risk silently reintroducing stale values in the wrong cases.
Recommended as a scoped follow-up, not attempted here.

### 42601 — dynamic SQL / no destination (5)

Explicitly out of scope this phase ("Do NOT touch dynamic SQL yet unless it belongs
to the chosen root cause"). Two are dynamic-SQL string-construction syntax errors
(`syntax error at or near "LEFT"/"DESC"`), two are `query has no destination for
result data` (procedures with a stray un-consumed `SELECT`, a different and
unrelated bug class).

### 42703, 42P19, 42P01, 22012 (5 + 2 + 1 + 1)

Small, heterogeneous, no shared pattern found. `board_getallboardcontents`'s
`column "month" does not exist` and `contacts_getcontactscount`/
`contacts_getcontactslist`'s `column "p_reguserno" does not exist` look like distinct,
unrelated bugs each needing individual source inspection. The two new 42P19s appeared
only after the `WITH RECURSIVE` fix unblocked their routines far enough to reach a
`UNION`/`UNION ALL` type-mismatch check between the anchor and recursive branches —
worth a follow-up but each is a single routine.

## Recommended next work (in priority order)

1. **Dependency pass**: convert and deploy the ~8 missing helper functions/procedures
   named in the 42883 bucket. This is scope/data work, not a converter code change,
   and would likely clear a meaningful slice of that bucket directly.
2. **`SELECT @var = expr` NULL-on-no-match fix**: implement `IF NOT FOUND THEN var :=
   <original default>; END IF;` injection, scoped carefully to single-variable
   assignments first. Would fix the 4 `sort`-column NOT NULL failures and likely
   others not yet surfaced.
3. **Alias-to-table type resolution for `+`/`||`**: thread `tableCatalog` into
   `ConvertProcedure` (currently function-only) so `col1 + col2` can be safely
   rewritten to `||` when both sides are confirmed string columns. Fixes the
   `character varying + character varying` cluster (6) without guessing.
4. **Per-routine polymorphic-procedure design**: for the multi-branch procedures
   (`contacts_getuserdata` and similar), decide a pattern (split functions vs.
   `SETOF record` with caller-supplied types) and apply it routine by routine — this
   is inherently one-off work, not a generalized rule.
5. Dynamic SQL syntax errors and the remaining one-off column/relation mismatches are
   lowest priority and best triaged individually once the above passes reduce noise.
