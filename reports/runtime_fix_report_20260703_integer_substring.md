# Runtime fix report - integer SUBSTRING assignments

Generated: 2026-07-03

| Status | Before | After | Delta |
|---|---:|---:|---:|
| Runtime PASS | 227 | 227 | 0 |
| Runtime FAIL | 28 | 23 | -5 |
| BLOCKED | 99 | 104 | +5 |

The converter now preserves SQL Server empty-string-to-zero coercion when a
`SUBSTRING(...)` result is assigned to a declared integer local. The rule does
not affect text variables.

Recovered from runtime failure:

- `contacts_getoutfile`
- `contacts_getoutfileexcel`
- `contacts_getoutlist`
- `contacts_getoutlistcount`
- `contacts_getoutlistexcel`

These routines no longer raise `22P02`. They are BLOCKED at the validation
layer because their `SETOF record` output metadata is not safely inferable.

Validation:

- Product build: PASS, 0 warnings/errors.
- NUnit regression: PASS, 78/78.
- Board QA: PASS, 24/24.
- Full runtime smoke: 227 PASS / 23 FAIL / 104 BLOCKED.
