# Runtime converter fix report - 2026-07-02 21:37 +07:00

- Before: 225 PASS / 30 FAIL / 99 BLOCKED.
- After: 227 PASS / 28 FAIL / 99 BLOCKED.
- Root cause: table-valued SQL Server functions with a line comment between
  `INSERT INTO @ReturnTable SELECT ...` and `RETURN` did not fold to
  PostgreSQL `RETURN QUERY`.
- General rule: return-table folding accepts intervening comments/whitespace.
- Rescued: `board_getboardallow`, `board_getfolderallow`.
- Files: `Converter.cs`, `tests/Regression/RegressionTests.cs`.
- Regression added: table return variable with a trailing diagnostic comment.
- Validation: build PASS; NUnit 77/77; Board QA 24/24; full runtime 227/28/99.
- Remaining leading groups: five empty-list dummy-data casts, four not-null
  sort/data failures, type mismatches, two XML temp-result failures, and
  dynamic SQL bindings.
- Next: pursue general converter type rules; leave data-dependent and external
  dependency failures explicit.
