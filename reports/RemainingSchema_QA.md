# Remaining Schema QA Report

This report analyzes the conversion and validation failures of all remaining database objects (procedures, functions, views, triggers, indexes, and constraints) that are not related to `Board%` or `Contact%`.

---

## 1. Summary of Remaining Schema
* **Total Non-Board/Contact Objects:** 3,890
  * **Procedures / Functions:** 2,125
  * **Tables:** 603
  * **Constraints:** 1,062 (TODO stubs)
  * **Indexes:** 84 (Standalone)
  * **Views:** 8 (TODO stubs)
  * **Triggers:** 8

---

## 2. Failure Classifications and Root Cause Analysis

### 1. Duplicate Parameter/Variable Declarations
* **PostgreSQL Error:** `parameter name used more than once` or `variable "name" declared more than once`
* **Root Cause:** The parameter name is declared in the function parameter signature, but also duplicated in the local variable `DECLARE` block (since T-SQL stored procedures declare variables and parameters using `@Name` and the converter fails to filter out parameter names from local declarations).
* **Estimated Affected Objects:** 343
* **Converter File to Modify:** [Converter.cs](file:///e:/pg_converter_ui/Converter.cs)
* **Complexity:** Low (Filter out parameter names from local `declares` list before appending to the DECLARE block).
* **Expected Impact:** Resolves 343 compilation errors.

### 2. Missing `THEN` due to Comment Shielding
* **PostgreSQL Error:** `missing "THEN" at end of SQL expression`
* **Root Cause:** A T-SQL comment is placed on the same line as the `IF` condition (e.g. `IF @Val = 0 -- comment`). When the converter appends `THEN` to the end of the line, it is placed after `--` and ignored by PostgreSQL as a comment.
* **Estimated Affected Objects:** 224
* **Converter File to Modify:** [BodyConverter.cs](file:///e:/pg_converter_ui/BodyConverter.cs)
* **Complexity:** Low (Place `THEN` keyword before comments or move comments to a separate line).
* **Expected Impact:** Resolves 224 syntax errors.

### 3. Syntax Errors near Reserved Keywords (desc, To, Left, Right, User)
* **PostgreSQL Error:** `syntax error at or near "desc"` / `syntax error at or near "To"`
* **Root Cause:** Column names or aliases that match PostgreSQL keywords (e.g., `desc`, `To`, `Left`, `Right`, `User`) are not quoted in DML statements.
* **Estimated Affected Objects:** 300+
* **Converter File to Modify:** [Converter.cs](file:///e:/pg_converter_ui/Converter.cs#L9)
* **Complexity:** Low (Add these keywords to the `PgReservedWords` Hashset).
* **Expected Impact:** Resolves 300+ syntax errors.

### 4. Default Value Type Mismatch (1/0 to Boolean, 'GETDATE')
* **PostgreSQL Error:** `invalid input syntax for type date: "GETDATE"` / `invalid input syntax for type boolean: "1"`
* **Root Cause:** MSSQL defaults like `@Active BIT = 1` or `@Date DATE = GETDATE` are converted incorrectly to `boolean DEFAULT 1` or `date DEFAULT 'GETDATE'` instead of `boolean DEFAULT true` or `date DEFAULT CURRENT_DATE`.
* **Estimated Affected Objects:** 381 (157 for GETDATE, 224 for numeric boolean defaults)
* **Converter File to Modify:** [Converter.cs](file:///e:/pg_converter_ui/Converter.cs#L929)
* **Complexity:** Medium (Improve type-aware default value parsing inside `MapDefault`).
* **Expected Impact:** Resolves 381 default-value syntax errors.

### 5. Semicolon-Shielded Semicolon Duplication (;;)
* **PostgreSQL Error:** `syntax error at or near ";"`
* **Root Cause:** Line endings containing `\r` (carriage return) shield the negative lookbehind in statement boundaries check, resulting in double semicolons `;;` being injected.
* **Estimated Affected Objects:** 150+
* **Converter File to Modify:** [Converter.cs](file:///e:/pg_converter_ui/Converter.cs#L964)
* **Complexity:** Low (Strip `\r` at the start of `ConvertBody`).
* **Expected Impact:** Resolves 150+ syntax errors.

### 6. Unconverted Cursors and Table Variables
* **PostgreSQL Error:** `syntax error at or near "OPEN"` / `syntax error at or near "table"`
* **Root Cause:** The parser strips `DECLARE cursor` and `DECLARE @t TABLE` blocks but leaves cursor commands (`OPEN`, `FETCH`) and table variable modifications unconverted.
* **Estimated Affected Objects:** 113 for Table variables, 50+ for Cursors
* **Converter File to Modify:** [BodyConverter.cs](file:///e:/pg_converter_ui/BodyConverter.cs)
* **Complexity:** Medium (Translate table variables to temporary tables and cursors to FOR loops).
* **Expected Impact:** Resolves 160+ compilation errors.
