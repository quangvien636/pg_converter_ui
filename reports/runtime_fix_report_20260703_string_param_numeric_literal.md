# Runtime fix report: string parameters compared with numeric literals

Generated: 2026-07-03

## Result

| Gate | Before | After |
|---|---:|---:|
| Runtime PASS | 261 | **263** |
| Runtime FAIL | 71 | **69** |
| Runtime BLOCKED | 22 | **22** |

All 261 baseline PASS routines remained PASS.

Recovered routines:

- `board_setshare`
- `contacts_setshare`

## Converter rule

When a generated PostgreSQL parameter is proven to be `character varying`,
`character`, or `text`, numeric equality and inequality literals are emitted
as string literals. For example, `_mode = 0` becomes `_mode = '0'`.

The rule is limited to declared string parameters. Integer comparisons stay
numeric and boolean comparisons continue to use the existing boolean rule.

## Validation

- Release build: PASS, 0 warnings/errors.
- NUnit regression: 112/112 PASS.
- Board regression QA: 24/24 PASS.
- Runtime smoke: 263 PASS / 69 FAIL / 22 BLOCKED.
- PASS regressions: 0.
