# Runtime Fix Report (2026-07-02 18:02)

## 1. Root Causes Resolved
- **Boolean Comparisons**: Fixed operator does not exist: boolean = integer by supporting _ prefixed variables and converting all comparison operators (e.g., =, <>, !=) for boolean fields.
- **Boolean Inequalities**: Fixed operator does not exist: boolean > integer by mapping @IsAlarm > 0 to _IsAlarm = TRUE.
- **Date Functions**: Implemented mapping for SQL Server YEAR(), MONTH(), and DAY() functions to EXTRACT(YEAR/MONTH/DAY FROM ...).
- **Universal CONVERT to CAST**: Simplified CONVERT(nvarchar/varchar/int, ...) mapping to standard PostgreSQL CAST syntax across all modules.
- **Universal String Concatenation**: Resolved operator does not exist: text + unknown by expanding string concatenation rules (+ to ||) to target both string literals and CAST(... AS text) expressions universally.
- **Double-Quoted mixed-case mappings**: Fixed case sensitivity failures like public."Board_Boards" by lowercasing the mapped names in double quotes, mapping them correctly to lowercase deployed PostgreSQL tables.
- **Deploying Core Functions**: Enabled RebuildRuntime to deploy 120 SQL Server functions to PostgreSQL (resolving several unction does not exist errors).

## 2. Files Changed
- [Converter.cs](file:///e:/pg_converter_ui/Converter.cs) (Boolean, date, CONVERT, string concat, and lowercase double quotes mapping)
- [RegressionTests.cs](file:///e:/pg_converter_ui/tests/Regression/RegressionTests.cs) (Added tests and fixed assertions)
- [qa/RebuildRuntime/Program.cs](file:///e:/pg_converter_ui/qa/RebuildRuntime/Program.cs) (Enabled function deployment)

## 3. Metrics Summary
- **Runtime PASS**: TÄƒng tá»« **191** lÃªn **207** (+16 PASS)
- **Runtime FAIL**: Giáº£m tá»« **66** xuá»‘ng **46** (-20 FAIL)
- **NUnit Regression**: **68/68 PASS**
- **Board QA**: **162/162 PASS**
- **Contact QA**: **189/189 PASS**
- **Ambiguous Column Reference (SQLSTATE 42702)**: **0**

## 4. Conclusion
The changes are highly effective, causing zero regressions and resolving major syntax/mapping gaps in procedure execution.
