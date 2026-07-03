# Runtime fix report: integral columns compared with string parameters

Generated: 2026-07-03

## Result

| Gate | Before | After |
|---|---:|---:|
| Runtime PASS | 263 | **266** |
| Runtime FAIL | 69 | **66** |
| Runtime BLOCKED | 22 | **22** |

All 263 baseline PASS routines remained PASS.

Recovered routines:

- `contacts_checkgroup`
- `contacts_getusernumber`
- `contacts_setcontactsrestore`

## Converter rule

For equality and inequality comparisons between a catalog-proven integral
table column and a declared string parameter, the converter now follows SQL
Server's numeric type precedence:

- NULL remains NULL.
- Empty or whitespace-only text becomes zero.
- Nonblank text is cast to the exact proven `smallint`, `integer`, or `bigint`
  column type.

Unknown columns, ambiguous column types, and string-to-string comparisons are
left unchanged.

## Validation

- Release build: PASS, 0 warnings/errors.
- NUnit regression: 114/114 PASS.
- Board regression QA: 24/24 PASS.
- Runtime smoke: 266 PASS / 66 FAIL / 22 BLOCKED.
- PASS regressions: 0.
