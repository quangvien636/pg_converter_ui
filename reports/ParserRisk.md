# Converter Parser Risk & Weakness Assessment Report

This report presents a thorough analysis of the regex weaknesses, edge cases, silent failures, and structural assumptions in the current parsing logic of `MssqlParser.cs` and `Converter.cs`.

---

## 1. MssqlParser Block Splitting Risks

### 1. The `GO` Splitting Regex (`(?m)^\s*GO\s*$`)
* **Risk Type:** Token Hijacking / Code Corruption
* **Converter File:** [MssqlParser.cs:11](file:///e:/pg_converter_ui/MssqlParser.cs#L11)
* **Weakness:** The parser splits the SQL script into blocks by matching lines that contain only `GO` (case-insensitive). However, it does not check if `GO` is inside a multi-line comment block (e.g. `/* ... \r\nGO\r\n ... */`) or a single/double-quoted string literal.
* **Edge Case:** If a stored procedure contains dynamic SQL or comments with a standalone `GO` statement, the parser splits the SQL statement mid-block. This creates two truncated, invalid SQL blocks that fail syntax validation.
* **Silent Failure:** Any block with a length of 10 characters or less after splitting is silently discarded (`b.Length > 10`), potentially swallowing lines of valid code.

### 2. Assumption of the `dbo` Schema
* **Risk Type:** Parser Silent Failure
* **Converter File:** [MssqlParser.cs:29,40,51,59](file:///e:/pg_converter_ui/MssqlParser.cs#L29)
* **Weakness:** Object type recognition regexes explicitly match the `dbo` schema name (e.g. `(?:\[?dbo\]?\.)?`).
* **Edge Case:** If the source database utilizes other schemas (e.g., `sales.Orders`, `hr.Employees`), the parser fails to recognize the schema pattern. It will either fail to match the block entirely (returning `null` and silently skipping the object) or match the schema name itself as the object name.

---

## 2. Parameter & Variable Extraction Weaknesses

### 1. Ignored Parameter SQL Comments
* **Risk Type:** Scope / Signature Corruption
* **Converter File:** [Converter.cs:875](file:///e:/pg_converter_ui/Converter.cs#L875)
* **Exact Function:** `ConvertParams`
* **Weakness:** The parameter splitter (`SplitParams`) parses the raw parameter block character-by-character but has no knowledge of SQL comment tokens (`--` and `/* ... */`).
* **Edge Case:** If a parameter block contains comments (e.g. `-- Add parameters here`), the comment text is concatenated into the split parameter part. The parser matching regex fails, outputting the parameter as an `-- UNPARSED:` comment line which is completely omitted from the converted function signature. This leaves the parameter undeclared and throws `not a known variable` errors at compile time.

### 2. Greedy Variable Extraction Regex
* **Risk Type:** Code Swallowing
* **Converter File:** [Converter.cs:74](file:///e:/pg_converter_ui/Converter.cs#L74)
* **Exact Function:** `ConvertProcedure`
* **Weakness:** Variables are extracted by looking for `^[ \t]*DECLARE\s+([^\r\n]+)\r?$` matching lines, which are then stripped from the body.
* **Edge Case:** If a `DECLARE` statement is commented out or located inside a string literal (e.g. dynamic SQL inside a stored procedure), the parser matches and removes it anyway. This corrupts the dynamic SQL string or comment block in the output function.
* **Mismatched Multi-Variable Declarations:** Declaring multiple variables separated by commas, where one variable contains a default value expression with a comma (e.g., `@val DECIMAL(10,2)`), will confuse the comma splitter and result in truncated variable definitions.

---

## 3. Semicolon Suffix Injection Weaknesses

### 1. Carriage Return (`\r`) shielding
* **Risk Type:** Syntax Error Injection
* **Converter File:** [Converter.cs:1034-1045](file:///e:/pg_converter_ui/Converter.cs#L1034)
* **Weakness:** Semicolons are appended to DML lines by checking the last character of a line using negative lookbehinds `(?<![;,])`.
* **Edge Case:** In Windows files, lines end with carriage returns `\r`. The lookbehind evaluates the `\r` character instead of the preceding semicolon `;`. It incorrectly concludes that no semicolon is present and appends a second one, generating invalid double semicolons `;;`.
* **Inline Comments Shielding:** If a statement already has a semicolon but ends with an inline comment (e.g., `UPDATE Table SET A=1; -- comment`), the negative lookbehind evaluates the comment text. It fails to detect the semicolon and appends another one, e.g., `; -- comment;`.
