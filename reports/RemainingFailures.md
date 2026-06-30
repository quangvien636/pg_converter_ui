# Remaining Failures Report

This report outlines the primary remaining compile failures, their root causes, implementation priorities, target converter files, and recommended fixes.

---

## Failure Matrix

### 1. Procedure Misclassification
*   **Target Procedures:** All MS SQL Stored Procedures (2,396 total)
*   **PostgreSQL Error:** Converted as `ObjectType.Function` using `RETURNS SETOF record` instead of PostgreSQL standard function/procedure DDL structures.
*   **Root Cause:** The database loader queries `sys.objects` and evaluates the `type` column. The type code is returned as a space-padded `char(2)` (e.g. `"P "`) instead of a single char `"P"`, bypassing the `ObjectType.Procedure` classification block.
*   **Priority:** **Critical (ROI: 2396/1 = 2396)**
*   **Expected Converter File:** [MssqlDbReader.cs](file:///e:/pg_converter_ui/MssqlDbReader.cs)
*   **Expected Implementation:** Trim the value returned by the database query or update the check to evaluate padded strings:
    ```csharp
    string typeCode = reader.GetString(typeColIndex).Trim();
    ```

### 2. View DDL Stubs
*   **Target Views:** All database views (8 total)
*   **PostgreSQL Error:** Emitted as TODO/STUB comments.
*   **Root Cause:** View bodies are not translated. The converter emits view definitions as block comment stubs.
*   **Priority:** **High (ROI: 8/5 = 1.6)**
*   **Expected Converter File:** [Converter.cs](file:///e:/pg_converter_ui/Converter.cs) (`ConvertView` method)
*   **Expected Implementation:** Parse view SELECT statements, strip MS SQL-specific query decorators (like `WITH SCHEMABINDING`, `NOLOCK` hints), and replace them with PostgreSQL view DDL syntax.

### 3. Standalone Constraint Stubs
*   **Target Constraints:** All defaults, primary keys, and foreign keys (1,240 total)
*   **PostgreSQL Error:** Emitted as TODO/STUB comments.
*   **Root Cause:** Standalone table alter statements are bypassed.
*   **Priority:** **High (ROI: 1240/5 = 248)**
*   **Expected Converter File:** [Converter.cs](file:///e:/pg_converter_ui/Converter.cs) (`ConvertConstraint` method)
*   **Expected Implementation:** Map MS SQL check condition clauses, default value definitions, and references statements to standard PostgreSQL `ALTER TABLE ADD CONSTRAINT` definitions.

### 4. Index Name Collision Bypasses
*   **Target Indexes:** Standalone and table indexes (531 total)
*   **PostgreSQL Error:** Loader silent bypasses (indexes are not created).
*   **Root Cause:** The index creator evaluates `indexname` across the entire schema. If a different table shares an index name, the loader skips compiling it, preventing covering index creation.
*   **Priority:** **High (ROI: 531/3 = 177)**
*   **Expected Converter File:** [MssqlDbReader.cs](file:///e:/pg_converter_ui/MssqlDbReader.cs)
*   **Expected Implementation:** Update index metadata lookups to check both table name and index name combinations, guaranteeing unique constraints do not conflict across tables.

### 5. Datatype Support Gaps (`sysname`, `datetimeoffset`)
*   **Target Procedures:** `sysdiagrams`, `WorkingTime_Times_v2`
*   **PostgreSQL Error:** `Type "sysname" does not exist` / `Type "datetimeoffset" does not exist`
*   **Root Cause:** MS SQL-specific type keywords are not mapped inside the datatype translator.
*   **Priority:** **Medium (ROI: 50/2 = 25)**
*   **Expected Converter File:** [Converter.cs](file:///e:/pg_converter_ui/Converter.cs) (`MapType` function)
*   **Expected Implementation:** Add specific case checks to map:
    *   `sysname` $\rightarrow$ `varchar(128)`
    *   `datetimeoffset` $\rightarrow$ `timestamp with time zone`

### 6. SQL Server Proprietary XML Functions
*   **Target Procedures:** `Board_InsertNotificationService`, `Board_UpdateNotificationService`, `Contacts_SaveAddressInfo`
*   **PostgreSQL Error:** `syntax error at or near "EXEC"`
*   **Root Cause:** Procedures invoke `sp_xml_preparedocument` and `OPENXML` statements.
*   **Priority:** **Medium (ROI: 3/5 = 0.6)**
*   **Expected Converter File:** [BodyConverter.cs](file:///e:/pg_converter_ui/BodyConverter.cs)
*   **Expected Implementation:** Map `sp_xml_preparedocument` to stubs and rewrite `OPENXML` structures to native `XMLTABLE` blocks:
    ```sql
    SELECT * FROM xmltable('/root/Details' PASSING xml_param COLUMNS col type PATH '.')
    ```
