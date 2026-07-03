# Runtime fix report - optional INSERT INTO

Generated: 2026-07-03

| Status | Before | After | Delta |
|---|---:|---:|---:|
| Runtime PASS | 227 | 227 | 0 |
| Runtime FAIL | 23 | 22 | -1 |
| BLOCKED | 104 | 105 | +1 |

SQL Server permits `INSERT Table (...) VALUES (...)` without the `INTO`
keyword. Boolean INSERT literal mapping now recognizes both forms.

Recovered from runtime failure:

- `board_insertboardcontent`

The routine no longer raises a boolean/integer type mismatch. It is BLOCKED at
the validation layer because its `SETOF record` output metadata is not safely
inferable.

Validation:

- Product build: PASS, 0 warnings/errors.
- NUnit regression: PASS, 79/79.
- Board QA: PASS, 24/24.
- Full runtime smoke: 227 PASS / 22 FAIL / 105 BLOCKED.
