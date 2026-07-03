# Runtime fix report - exact temp-table return metadata

Generated: 2026-07-03

| Status | Before | After | Delta |
|---|---:|---:|---:|
| Runtime PASS | 227 | 228 | +1 |
| Runtime FAIL | 22 | 22 | 0 |
| BLOCKED | 105 | 104 | -1 |

The converter now emits `RETURNS TABLE` when the final result is exactly
`SELECT *` from a locally declared temp table and every declared output column
has a recognized type. It does not infer names or types from expressions.

Recovered:

- `board_getdepartandpositionname`

Validation:

- Product build: PASS, 0 warnings/errors.
- NUnit regression: PASS, 80/80.
- Board QA: PASS, 24/24.
- Full runtime smoke: 228 PASS / 22 FAIL / 104 BLOCKED.
