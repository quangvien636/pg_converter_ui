# Deep Parser Audit (Nested Structures & Delimiters)

This audit analyzes the parsing logic of `Converter.cs` and `BodyConverter.cs` focusing on nested code structures, delimiter placement, and schema translation.

---

## 1. Nested Code Block Parsing Audit

### 1. Nested `BEGIN` / `END` Blocks
* **Vulnerability:** Mismatched block boundaries.
* **Analysis:** In PL/pgSQL, a `BEGIN ... END;` block acts as both a control flow wrapper and an exception/variable scope block. Each block must end with a semicolon-terminated `END;`.
* **Weakness:** The converter handles block delimiters using flat regex replacements rather than maintaining a syntax tree or stack of nesting depths.
* **Edge Case:** In stored procedures with deeply nested sub-blocks (e.g. `IF Cond BEGIN ... BEGIN ... END END END`), the regex swaps fail to match the correct nesting depth, leaving some `END` keywords without semicolons, which triggers `syntax error at end of input` or `syntax error at or near "END"`.

### 2. Nested `IF` and `WHILE` Loops
* **Vulnerability:** Block closure truncation.
* **Analysis:** PostgreSQL requires `END IF;` and `END LOOP;` for closing conditional and loop statements, whereas T-SQL uses bare `END` statements.
* **Weakness:** The converter maps `ELSE IF` to `ELSIF` or `ELSE IF ... THEN` using flat replacements, but lacks a matching stack to determine which `END` corresponds to which `IF`.
* **Edge Case:** If an outer `IF` contains a nested `IF` inside its `ELSE` branch, the parser cannot reliably match the nested boundaries. It often omits a required `END IF;` or places it at the incorrect statement boundary.

### 3. Nested `TRY` / `CATCH` Exception Blocks
* **Vulnerability:** Invalid PL/pgSQL block structures.
* **Analysis:** T-SQL `BEGIN TRY ... END TRY BEGIN CATCH ... END CATCH` blocks can be placed inline anywhere. In PostgreSQL PL/pgSQL, exception handlers (`EXCEPTION WHEN OTHERS THEN`) can **only** be declared at the end of a `BEGIN ... END;` block.
* **Weakness:** The converter does not wrap T-SQL `TRY` blocks inside a nested sub-block `BEGIN ... EXCEPTION ... END;`.
* **Edge Case:** Translating inline T-SQL `TRY` blocks without wrapping them in `BEGIN ... END;` sub-blocks results in invalid PostgreSQL syntax, as the compiler rejects `EXCEPTION` statements placed mid-block.

---

## 2. Delimiter & Statement Boundary Audit

### 1. Missing Semicolon Delimiters
* **Vulnerability:** Merged statements.
* **Analysis:** PostgreSQL PL/pgSQL requires semicolons `;` as statement delimiters after all DML operations, variable assignments, and block closers.
* **Weakness:** The converter's boundary detector only appends semicolons to lines matching specific regex keyword starts (e.g. `INSERT`, `UPDATE`, `DELETE`).
* **Edge Case:** If a statement spans multiple lines, the regex will either append semicolons to intermediate lines (breaking the query) or fail to detect the end of the statement if it terminates on a line that does not match the keyword start, leading to syntax errors on subsequent lines.

### 2. Schema Resolution Weaknesses
* **Vulnerability:** Unconverted schema brackets.
* **Analysis:** SQL Server schema references can be written as `dbo.Table`, `[dbo].[Table]`, or `dbo.[Table]`.
* **Weakness:** The converter uses `\bdbo\.(\w+)\b` or basic regexes to replace schemas.
* **Edge Case:** References like `dbo.[Table]` may be translated to `public.[Table]` instead of `public."Table"` because the converter fails to replace the brackets on the table name. Unquoted brackets trigger immediate PostgreSQL compilation errors.
