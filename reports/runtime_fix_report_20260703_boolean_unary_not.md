# Runtime fix report: boolean unary NOT

Generated: 2026-07-03

## Result

| Gate | Before | After |
|---|---:|---:|
| Runtime PASS | 266 | **269** |
| Runtime FAIL | 66 | **63** |
| Runtime BLOCKED | 22 | **22** |

All 266 baseline PASS routines remained PASS.

Recovered routines:

- `board_getboardbyuserno`
- `board_getfolderbyuserno`
- `board_getfolders`

## Converter rule

SQL Server accepts unary `~` on `BIT` values. PostgreSQL represents converted
`BIT` parameters as boolean, where the equivalent operator is logical `NOT`.
The converter now changes `~parameter` to `(NOT parameter)` only when its
generated parameter declaration proves the parameter is boolean.

Integral parameters retain the bitwise `~` operator.

## Validation

- Release build: PASS, 0 warnings/errors.
- NUnit regression: 116/116 PASS.
- Board regression QA: 24/24 PASS.
- Runtime smoke: 269 PASS / 63 FAIL / 22 BLOCKED.
- PASS regressions: 0.
