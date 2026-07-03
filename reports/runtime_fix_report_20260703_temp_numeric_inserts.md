# Runtime fix report - temp-table numeric INSERT typing

Generated: 2026-07-03

| Status | Before | After | Delta |
|---|---:|---:|---:|
| Runtime PASS | 228 | 229 | +1 |
| Runtime FAIL | 22 | 20 | -2 |
| BLOCKED | 104 | 105 | +1 |

The converter now uses explicit local temp-table schemas to preserve SQL
Server text-to-numeric INSERT coercion. The rule fires only for known text
parameters or `SUBSTRING` expressions targeting declared numeric columns.

Results:

- `contacts_updatecontactsuser`: FAIL to PASS.
- `contacts_setcontactsuser`: FAIL to BLOCKED (`SETOF record` metadata).

Validation:

- Product build: PASS, 0 warnings/errors.
- NUnit regression: PASS, 81/81.
- Board QA: PASS, 24/24.
- Full runtime smoke: 229 PASS / 20 FAIL / 105 BLOCKED.
