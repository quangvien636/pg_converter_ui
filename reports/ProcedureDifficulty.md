# Stored Procedure Migration Difficulty Classification

This report classifies the 2,396 stored procedures from the SQL Server database by their migration complexity to PostgreSQL, and estimates the converter work required.

---

## Difficulty Summary Table

| Category | Complexity Description | Estimated Count | Converter Work Required |
|----------|------------------------|-----------------|-------------------------|
| **Easy** | Simple SELECT, INSERT, UPDATE, and DELETE queries without complex logic or variables. | 1,800 (75%) | Only requires statement semicolon suffix injection. |
| **Medium** | Stored procedures with local variables, temp tables, basic control flow (IF/ELSE, WHILE), and transaction statements. | 400 (17%) | Requires: <br>1. Semicolon normalization.<br>2. Parameter/variable duplicate filter.<br>3. Temp table marker (#) stripping.<br>4. Transaction statement removal. |
| **Hard** | Stored procedures using cursors, table variables, dynamic SQL, XML parsing (`OPENXML`), and exception handling (`TRY/CATCH`). | 180 (7.5%) | Requires:<br>1. Cursor-to-loop translation.<br>2. Table variable-to-temp table mapping.<br>3. Dynamic SQL parameters mapping.<br>4. Exception block translations. |
| **Unsupported** | Stored procedures utilizing CLR, Service Broker, or native MS-SQL replication/system procedures. | 16 (0.5%) | Unsupported automatically; must be flagged for manual rewrite. |

---

## Detailed Classification Matrix

### 1. Easy Category (Low Effort)
* **Estimated count:** 1,800 procedures.
* **T-SQL Features Used:** Standard CRUD DML operations, simple where clauses, constant defaults.
* **Converter Fix Needed:** Semicolon suffix injection (requires the carriage return `\r` removal fix to stop double semicolons `;;` from occurring).

### 2. Medium Category (Moderate Effort)
* **Estimated count:** 400 procedures.
* **T-SQL Features Used:** `@variables`, `#temp` tables, `IF / ELSE` logic, `WHILE` loops, `BEGIN/COMMIT TRAN`.
* **Converter Fix Needed:**
  * Regex filters to remove parameter name duplications inside local `DECLARE` blocks.
  * Semicolon injection suffix formatting for loops and conditional endings.
  * Regex cleanups to automatically strip T-SQL `TRAN` keywords.

### 3. Hard Category (High Effort)
* **Estimated count:** 180 procedures.
* **T-SQL Features Used:** `CURSOR` loops, `DECLARE @t TABLE` declarations, `sp_executesql` calls, `OPENXML` statements, `BEGIN TRY ... BEGIN CATCH` blocks.
* **Converter Fix Needed:**
  * **Cursors:** Map cursor syntax to native PL/pgSQL loops: `FOR rec IN SELECT ... LOOP`.
  * **Table Variables:** Map `DECLARE @t TABLE(...)` to `CREATE TEMP TABLE t(...)` and replace all `@t` references with `t`.
  * **Dynamic SQL:** Map `sp_executesql` to `EXECUTE format(...)` or handle native PG dynamic execute.
  * **Exception Handling:** Map `BEGIN TRY ... END TRY BEGIN CATCH ... END CATCH` to PL/pgSQL `BEGIN ... EXCEPTION WHEN OTHERS THEN ... END;` blocks.

### 4. Unsupported Category (Manual Rewrite Required)
* **Estimated count:** 16 procedures.
* **T-SQL Features Used:** `xp_cmdshell` calls, Service Broker queues, CLR assemblies, full-text catalog index maintenance commands.
* **Converter Fix Needed:** None. The converter should output a blocker warning and comment out the body, prompting manual developer rewriting.
