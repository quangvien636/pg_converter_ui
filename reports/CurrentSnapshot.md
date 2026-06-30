# Current Snapshot

**Snapshot date:** 2026-06-30  
**Branch / HEAD:** `master` / `3cace89`  
**Scope:** Reconstructed from the designated handoff, QA, roadmap, iteration, regression, and rules reports.

## Validated Procedure Baseline

| Suite | PASS | FAIL | Total | Compile rate | Regressions |
|---|---:|---:|---:|---:|---:|
| Build | PASS | 0 errors | — | — | 0 |
| NUnit | 26 | 0 | 26 | 100% | 0 |
| Board% | 146 | 16 | 162 | 90.1% | 0 |
| Contact% | 118 | 71 | 189 | 62.4% | 0 |

The authoritative latest procedure totals come from `PostCommit_QA.md`. The Board and Contact report timestamps were refreshed in the current uncommitted worktree.

## Separate Production-Catalog Baseline

| Metric | Count |
|---|---:|
| Catalog objects | 5,052 |
| Strict PASS | 745 |
| FAIL / bypassed | 4,307 |
| Strict compile rate | 14.7% |
| PostgreSQL files with errors | 2,285 |

This production-catalog run is not the same measurement as Board% procedure QA. Its largest clusters include procedure classification, constraint/view stubs, and index loading.

## Implemented Converter Capabilities Reported by Handoffs

- Line-ending and trailing-whitespace normalization.
- Comment-safe `THEN` / `LOOP` placement and generalized `ELSE BEGIN` handling.
- `UPDATE SET` target-alias stripping.
- Duplicate procedure/function parameter versus local-variable filtering.
- Date default mapping for `GETDATE`.
- Reserved identifier quoting.
- Table-variable/temp-table conversion.
- Cursor lifecycle conversion.
- Transaction-control stripping.
- Inner `ORDER BY` removal before `UNION`.
- XML handling/stubbing for `sp_xml_preparedocument` and `OPENXML`.

Some of these capabilities are represented by pre-existing uncommitted changes. “Reported implemented” does not grant permission to commit those changes.

## Current Worktree State

- Before generating this snapshot set: 66 modified and 132 untracked files.
- No staged, deleted, or renamed files.
- The modified converter and regression tests form a coherent duplicate-declaration fix.
- Board and Contact SQL corpora appear regenerated.
- The entire pre-existing worktree, including `$null`, is treated as intentional until proven otherwise.
- Full ownership and purpose notes are in `Uncommitted_Work_Inventory.md`.

## Operational Rules

- PostgreSQL compatibility target remains 9.3, even though validation reports identify a PostgreSQL 15.7 test server.
- Never edit generated SQL directly; fix the converter and regenerate.
- Add regex timeouts to replacement loops.
- Normalize line endings at body-conversion entry points.
- Preserve local variables that do not conflict with parameters.
- Build and run `scratch/run_post_commit_qa.ps1` before each implementation commit.
- Implement, validate, commit, and report one rank at a time.

## Current Decision

No implementation is authorized in this snapshot step. The next implementation must first separate its changes from the preserved pre-existing worktree.
