# Runtime converter fix report - 2026-07-02 21:26 +07:00

- Before: 224 PASS / 32 FAIL / 98 BLOCKED.
- After: 225 PASS / 30 FAIL / 99 BLOCKED.
- Root cause: raw SELECT heuristics missed final scalar results such as
  `SELECT CAST(1 AS BIT)`.
- General rule: a converted standalone scalar/boolean SELECT is treated as a
  result set and receives `RETURN QUERY`.
- Rescued: `board_updateallowaccess`.
- `board_updatespectype` is no longer a runtime FAIL, but remains BLOCKED
  because its record column type is not safely inferable.
- XML temp-table stubs were investigated; destinationless XML SELECTs remain
  genuine FAIL and were not suppressed.
- Files: `Converter.cs`, `BodyConverter.cs`,
  `tests/Regression/RegressionTests.cs`,
  `tests/Regression/UnsupportedFeaturesTests.cs`.
- Regression added: standalone converted scalar result and XML temp target
  preservation.
- Validation: build PASS; NUnit 76/76; Board QA 24/24; full runtime 225/30/99.
- Next: table-valued return-variable relations, then type mismatches.
