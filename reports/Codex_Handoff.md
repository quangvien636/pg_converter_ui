# Codex Developer Handoff

This document details the current status, code rules, validation commands, and priorities for the next developer/AI agent to continue the database converter migration.

---

## 1. Project Context & Current Git Commit

*   **Current Git Commit:** `3cace89bb261aaa4a2762fe892762b528a6bc2d9`
*   **Workspace Folder:** `e:\pg_converter_ui`
*   **Target Database Server:** PostgreSQL 9.3 (`pg_converter_runtime_test`)

---

## 2. Current PASS Metrics

*   **Build Status:** **PASS** (0 warnings, 0 errors on `dotnet build`)
*   **NUnit Regression Tests:** **PASS** (`26/26` tests compile and execute successfully)
*   **Board QA Integration Runner:** **PASS** (`24/24` representative procedural test checks pass successfully)
*   **Production Validation Scale:**
    *   Strict PASS: `745 / 5,052` (14.7%) objects compile correctly on the PostgreSQL server.
    *   FAIL / Bypassed: `4,307` objects (due to views/constraints stubs, procedure misclassifications, and index exclusions).

---

## 3. Completed Rank 1-10 Fixes

1.  **Rank 1 (Whitespace Shielding):** Normalized carriage returns (`\r\n` $\rightarrow$ `\n`) early in the pipeline to prevent lookbehinds from emitting double semicolons `;;`.
2.  **Rank 2 (Duplicate Declare Filter):** Filtered out procedure parameter names from the local variable `DECLARE` blocks.
3.  **Rank 3 (Comment Shielding):** Appended block keywords (`THEN`, `LOOP`) before trailing comments instead of after.
4.  **Rank 4 (Date Default Mapping):** Mapped `GETDATE` and `GETDATE()` parameter defaults to `CURRENT_DATE`/`now()` instead of wrapping them in single quotes.
5.  **Rank 5 (Reserved Word Quoting):** Added keywords like `desc`, `To`, `Left`, `Right`, `User`, `Position` to the reserved words list to trigger double quotes (`""`).
6.  **Rank 6 (Table Variables):** Translated T-SQL `@table_variable` declarations to `CREATE TEMP TABLE ... ON COMMIT DROP`.
7.  **Rank 7 (T-SQL Cursors):** Converted cursors (`OPEN`, `FETCH`, `CLOSE`, `DEALLOCATE`) to PL/pgSQL `FOR record IN SELECT ... LOOP` structures.
8.  **Rank 8 (Transaction Control):** Stripped illegal transaction keywords (`BEGIN TRAN`, `COMMIT TRAN`, etc.) from function bodies.
9.  **Rank 9 (Union Order By):** Stripped redundant inner `ORDER BY` statements directly preceding `UNION`/`UNION ALL` keywords in subqueries.
10. **Rank 10 (XML Processing):** Bypassed `sp_xml_preparedocument` DDL and mapped `OPENXML` blocks to PostgreSQL `XMLTABLE` stubs.

---

## 4. Remaining Backlog & ROI Priorities

| Priority | Expected PASS Increase | Complexity (1-10) | Risk | Target File | Target Function | Description |
|---|---|---|---|---|---|---|
| **1 (Critical)** | **+2,396** | 1 | Low | [MssqlDbReader.cs](file:///e:/pg_converter_ui/MssqlDbReader.cs) | `Load` (Catalog query) | **Procedure Misclassification Fix:** Trim space padding from `sys.objects.type` (e.g. `"P "` vs `"P"`). |
| **2 (High)** | **+1,248** | 5 | Low | [Converter.cs](file:///e:/pg_converter_ui/Converter.cs) | `ConvertView` / `ConvertConstraint` | **View & Constraint DDL:** Expand constraints and view stubs into PostgreSQL equivalents. |
| **3 (High)** | **+531** | 3 | Low | [MssqlDbReader.cs](file:///e:/pg_converter_ui/MssqlDbReader.cs) | `LoadIndexes` (Metadata query) | **Index Collision Bypass:** Evaluate unique combinations of table and index names. |
| **4 (Medium)** | **+300** | 4 | Low | [Converter.cs](file:///e:/pg_converter_ui/Converter.cs) | `ConvertBody` | **Quote Keywords in DML:** Quote columns matching reserved words inside queries. |
| **5 (Medium)** | **+50** | 2 | Low | [Converter.cs](file:///e:/pg_converter_ui/Converter.cs) | `MapType` | **Datatype Mappings:** Map `sysname` $\rightarrow$ `varchar(128)` and `datetimeoffset` $\rightarrow$ `timestamptz`. |

---

## 5. Coding Rules

1.  **Safe Regex Timeout:** Always specify a timeout (e.g., `TimeSpan.FromSeconds(5)`) for regex replaces to prevent catastrophic backtracking.
2.  **Early Line Normalization:** Replace `\r\n` with `\n` at the entry point of body conversion to prevent double semicolon errors.
3.  **Non-destructive Stubs:** Flag unsupported features (CLR assemblies, service brokers) using TODO warning comments instead of letting them fail silently.
4.  **Verification Check:** Execute NUnit tests and Board QA runners before pushing any commits.
5.  **Scope Safety:** Ensure table variables and temp table drops are restricted to transactional/local scopes.

---

## 6. Execution & Validation Commands

*   **Compile application:**
    ```powershell
    dotnet build
    ```
*   **Run NUnit Regression Suite:**
    ```powershell
    dotnet test e:\pg_converter_ui\tests\Regression\Regression.csproj
    ```
*   **Run Board QA Integration Runner:**
    ```powershell
    dotnet run --project e:\pg_converter_ui\qa\BoardRegressionTests\BoardRegressionTests.csproj
    ```

---

## 7. Files Directory Guide

### Files to Edit
*   [MssqlDbReader.cs](file:///e:/pg_converter_ui/MssqlDbReader.cs): Target for classification fixes and query trims.
*   [Converter.cs](file:///e:/pg_converter_ui/Converter.cs): Target for DDL structural changes, view parsing, and data type additions.
*   [BodyConverter.cs](file:///e:/pg_converter_ui/BodyConverter.cs): Target for date arithmetic, functions string modifications, and DML mappings.

### Files NOT to Edit
*   [qa/BoardRegressionTests/Program.cs](file:///e:/pg_converter_ui/qa/BoardRegressionTests/Program.cs): Integration runner tests.
*   [tests/Regression/RegressionTests.cs](file:///e:/pg_converter_ui/tests/Regression/RegressionTests.cs): Core NUnit regression assertions.
*   [tests/Regression/UnsupportedFeaturesTests.cs](file:///e:/pg_converter_ui/tests/Regression/UnsupportedFeaturesTests.cs): Feature syntax verification tests.
*   [Logger.cs](file:///e:/pg_converter_ui/Logger.cs): Stable daily rotation logging module.
*   [Models.cs](file:///e:/pg_converter_ui/Models.cs): Schema models core mapping structures.
*   [Program.cs](file:///e:/pg_converter_ui/Program.cs): Startup application lifecycles.

---

## 8. Expected Next Step

*   **Current Action Priority:** Fix the stored procedure catalog load categorization bug.
*   **Expected First Commit:** Trim the type string returned inside [MssqlDbReader.cs](file:///e:/pg_converter_ui/MssqlDbReader.cs) when querying database catalogs, ensuring objects matching `"P "` are correctly processed as `ObjectType.Procedure` (yielding a +2,396 PASS increase).
