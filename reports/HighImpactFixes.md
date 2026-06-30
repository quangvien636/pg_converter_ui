# High-Impact Fixes (20+ Objects Affected)

This report lists all identified converter defects that affect 20 or more SQL objects across the database schema, ranked by Return on Investment (ROI = impact / difficulty).

---

## High-Impact Fixes Registry

### 1. Carriage Return `\r` Semicolon Shielding (;; Injection)
* **Root Cause:** Semicolon checks use lookbehinds `(?<![;,])` which evaluate the trailing `\r` of Windows line endings instead of the semicolon, appending a second semicolon (`;;`) or failing to append a statement terminator.
* **Estimated Affected Objects:** 300+
* **Converter File:** [Converter.cs](file:///e:/pg_converter_ui/Converter.cs)
* **Function:** `Convert` or start of `ConvertBody`
* **Difficulty:** **Very Low (1/10)** (Normalize `\r\n` to `\n` at the entry point).
* **Expected PASS Increase:** **+300 objects**
* **ROI Rank:** 1

---

### 2. Duplicate Parameter/Variable Declarations in Stored Procedures
* **Root Cause:** The parser extracts parameter names and local variable names separately. However, it fails to verify if local variables match parameter names. Declaring a parameter and a local variable with the same name in the same block causes PL/pgSQL compilation errors.
* **Estimated Affected Objects:** 343
* **Converter File:** [Converter.cs](file:///e:/pg_converter_ui/Converter.cs)
* **Function:** `ConvertProcedure` / `ConvertFunction`
* **Difficulty:** **Low (2/10)** (Filter out parameter names from local variable declares).
* **Expected PASS Increase:** **+343 objects**
* **ROI Rank:** 2

---

### 3. Comment Shielding of block keywords (`THEN` / `LOOP`)
* **Root Cause:** A T-SQL comment at the end of an `IF` condition (e.g. `IF @val = 0 -- comment`) shields the appended `THEN` keyword from PostgreSQL because it is appended on the same line after `--`.
* **Estimated Affected Objects:** 224
* **Converter File:** [BodyConverter.cs](file:///e:/pg_converter_ui/BodyConverter.cs)
* **Function:** `ConvertBody`
* **Difficulty:** **Low (2/10)** (Place `THEN` or `LOOP` keyword before comment lines or move comments to separate lines).
* **Expected PASS Increase:** **+224 objects**
* **ROI Rank:** 3

---

### 4. Parameter Default date wrapping ('GETDATE')
* **Root Cause:** Parameter defaults like `@Date DATE = GETDATE` are converted to `'GETDATE'` string literal defaults by the word wrapper.
* **Estimated Affected Objects:** 157
* **Converter File:** [Converter.cs](file:///e:/pg_converter_ui/Converter.cs#L929)
* **Function:** `MapDefault`
* **Difficulty:** **Low (2/10)** (Check for GETDATE/GETDATE() and translate to CURRENT_DATE before quote wrapping).
* **Expected PASS Increase:** **+157 objects**
* **ROI Rank:** 4

---

### 5. Reserved Words (desc, To, Left, Right, User) Unquoted
* **Root Cause:** Table columns matching PostgreSQL reserved keywords are not double-quoted in DML statements.
* **Estimated Affected Objects:** 300+
* **Converter File:** [Converter.cs](file:///e:/pg_converter_ui/Converter.cs#L9)
* **Function:** `PgReservedWords` Hashset definition
* **Difficulty:** **Very Low (1/10)** (Simply add these keywords to the hashset).
* **Expected PASS Increase:** **+200 objects**
* **ROI Rank:** 5

---

### 6. Table Variables (`DECLARE @t TABLE`) Left Unconverted
* **Root Cause:** Table variables are parsed as empty strings in `DECLARE` blocks, leaving DML statements referencing `@t` unconverted.
* **Estimated Affected Objects:** 113
* **Converter File:** [BodyConverter.cs](file:///e:/pg_converter_ui/BodyConverter.cs)
* **Function:** `ConvertBody` / `ConvertTempTables`
* **Difficulty:** **Medium (5/10)** (Rewrite table variables to temporary tables and replace `@t` references).
* **Expected PASS Increase:** **+113 objects**
* **ROI Rank:** 6

---

### 7. T-SQL Cursors Left Unconverted
* **Root Cause:** Bare cursor manipulation commands (`OPEN`, `FETCH`, `CLOSE`, `DEALLOCATE`) are left untouched in PL/pgSQL body.
* **Estimated Affected Objects:** 50+
* **Converter File:** [BodyConverter.cs](file:///e:/pg_converter_ui/BodyConverter.cs)
* **Function:** `ConvertBody`
* **Difficulty:** **Medium (5/10)** (Translate cursor blocks to `FOR record IN SELECT ... LOOP` blocks).
* **Expected PASS Increase:** **+50 objects**
* **ROI Rank:** 7

---

### 8. Transaction Control Keywords (`BEGIN TRAN`, `COMMIT TRAN`)
* **Root Cause:** PL/pgSQL functions do not support transaction commands inside function bodies; statements must be stripped or rewritten for procedures.
* **Estimated Affected Objects:** 50+
* **Converter File:** [BodyConverter.cs](file:///e:/pg_converter_ui/BodyConverter.cs)
* **Function:** `ConvertBody`
* **Difficulty:** **Low (3/10)** (Regex strip transaction controls for functions).
* **Expected PASS Increase:** **+50 objects**
* **ROI Rank:** 8
