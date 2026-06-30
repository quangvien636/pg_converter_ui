# Developer Handoff Report

This report provides the technical handoff details for continuing the database migration project from Microsoft SQL Server to PostgreSQL 9.3.

---

## 1. Project Overview

*   **Current Objective:** Migrate schema structures (tables, views, indexes, constraints) and procedures/functions of the MS SQL Server database (`CrewCloud_Company_Bootstrap`) to PostgreSQL 9.3 (`pg_converter_runtime_test`). The primary focus is to automate the conversion of `Board%` and `Contact%` modules with high compilation and execution fidelity.
*   **Architecture:** Desktop WinForms application built in C# targeting `.NET 10.0-windows`. The tool maps SQL schemas and T-SQL bodies to PostgreSQL SQL and PL/pgSQL using regex-based pattern matching:
    *   [MssqlDbReader.cs](file:///e:/pg_converter_ui/MssqlDbReader.cs): Connects to the source database and extracts catalog definitions (tables, columns, routines, indexes).
    *   [MssqlParser.cs](file:///e:/pg_converter_ui/MssqlParser.cs): Splits and parses SQL scripts based on `GO` blocks.
    *   [Converter.cs](file:///e:/pg_converter_ui/Converter.cs): Orchestrates top-level script construction (creating DDL structures, mapping types, wrapping functions).
    *   [BodyConverter.cs](file:///e:/pg_converter_ui/BodyConverter.cs): Translates procedural block statements (assignments, control flow, cursors, temp tables).
    *   [Logger.cs](file:///e:/pg_converter_ui/Logger.cs): Writes conversion logs.
*   **Converter Workflow:**
    ```mermaid
    graph TD
        A[Load Objects from catalog/file] --> B[Dispatch by ObjectType]
        B --> C{Routine Type?}
        C -->|Procedure/Function| D[Extract DDL Headers & Params]
        D --> E[Isolate Body & Normalize Line Endings to \n]
        E --> F[BodyConverter: Try/Catch, Boilerplate, Cursors, Temp Tables, Control Flow]
        F --> G[Converter: Combine DDL Headers, Declares, and Body]
        G --> H[Emit PostgreSQL SQL Script with Warnings]
    ```

---

## 2. Current Baseline

*   **Commit Hash Bắt Đầu:** `3cace89bb261aaa4a2762fe892762b528a6bc2d9`
*   **Baseline QA Chính Thức (Official Baseline QA):**
    *   **NUnit Tests Baseline:** **20 PASS** (Hiện tại đạt `26/26` unit tests PASS)
    *   **Board% Procedures Baseline:** **140 PASS** (QA runner compile PASS)
    *   **Contact% Procedures Baseline:** **107 PASS** (QA runner compile PASS)
*   **Build Status:** **PASS** (`0 Warnings`, `0 Errors` on `dotnet build`)
*   **Production Validation Scale:**
    *   Total Objects in Catalog: `5,052`
    *   Strict PASS: `745` (14.7%)
    *   FAIL / Bypassed: `4,307` (85.3%)
    *   PostgreSQL Files with Error: `2,285`

---

## 3. Completed Fixes

### Rank 1: Carriage Return `\r` Semicolon Shielding Normalization
*   **Root Cause:** The statement terminator regex utilized a negative lookbehind `(?<![;,])` looking at the trailing character. In Windows-encoded files, lines ended with `\r\n`, shielding the lookbehind and resulting in duplicate semicolons `;;` that broke compilation.
*   **Files Modified:** [Converter.cs](file:///e:/pg_converter_ui/Converter.cs) (body normalization entry point) and [BodyConverter.cs](file:///e:/pg_converter_ui/BodyConverter.cs) (replaces `\r\n` with `\n`).
*   **Regression Tests Added:** `TestCarriageReturnDoubleSemicolon` (NUnit) and `Board_DeleteDepartAllowAccess_Regression` (QA).
*   **PASS Improvement:** Resolved compile syntax failures across +7 Board procedures, +30+ Contact procedures, and +150 on scale.

### Rank 2: Duplicate Parameter/Variable Declaration Filter
*   **Root Cause:** local variable declarations in MS SQL procedures used `@name`, which matching parameters also used. The converter declared these parameters in the header and local variables in the `DECLARE` section, causing duplicate identifier compiler failures.
*   **Files Modified:** [Converter.cs](file:///e:/pg_converter_ui/Converter.cs) (filters parameter list names out of the local declares).
*   **Regression Tests Added:** `TestDuplicateParamVarDeclarationFiltered` and `TestNonDuplicateDeclareKept`.
*   **PASS Improvement:** Fixed +8 Contact procedures and +343 objects on scale.

### Rank 3: Comment Shielding Block Keyword Formatting (`THEN`/`LOOP`)
*   **Root Cause:** In MS SQL, comments can sit on the same line as condition clauses. When appending `THEN` or `LOOP` to block headers, the converter put them after `--`, leaving them ignored by the PL/pgSQL compiler and causing structural compile failures.
*   **Files Modified:** [BodyConverter.cs](file:///e:/pg_converter_ui/BodyConverter.cs) (extracts trailing line comments and appends keywords before them).
*   **Regression Tests Added:** `TestCommentShieldingIfThen` and `TestCommentShieldingWhileLoop`.
*   **PASS Improvement:** Resolved +4 Board, +25 Contact, and +224 objects on scale.

### Rank 4: Date Default Parsing (`GETDATE` -> `CURRENT_DATE`)
*   **Root Cause:** Defaults like `@d DATE = GETDATE` were incorrectly parsed by matching against word structures and wrapping in quotes, yielding `DEFAULT 'GETDATE'`, causing type conversion compile failures.
*   **Files Modified:** [Converter.cs](file:///e:/pg_converter_ui/Converter.cs#L929) (added specific date-function mappings inside `MapDefault`).
*   **Regression Tests Added:** `TestGetDateParameterDefault`.
*   **PASS Improvement:** Fixed +4 Contact procedures and +157 objects on scale.

### Rank 5: Double-Quoting Reserved Keywords (desc, To, Left, Right, User)
*   **Root Cause:** Standard reserved keywords like `desc`, `To`, `Left` used as columns/variables were emitted raw, triggering PostgreSQL syntax parser errors.
*   **Files Modified:** [Converter.cs](file:///e:/pg_converter_ui/Converter.cs#L9) (added these to the `PgReservedWords` Hashset).
*   **Regression Tests Added:** `TestReservedWordPosition`.
*   **PASS Improvement:** Resolved +4 Contact procedures and +300+ objects on scale.

### Rank 6: Table Variables to Temp Tables Conversion
*   **Root Cause:** The parser left `@table_variable` references in the body block, causing syntax errors in subsequent queries.
*   **Files Modified:** [BodyConverter.cs](file:///e:/pg_converter_ui/BodyConverter.cs) (translates `@table_variable` declarations to `CREATE TEMP TABLE ... ON COMMIT DROP`).
*   **Regression Tests Added:** `TestTableVariables`.
*   **PASS Improvement:** +113 objects on scale compiled successfully.

### Rank 7: Unconverted Cursors to Loops
*   **Root Cause:** Cursors lifecycle statements (`OPEN`, `FETCH NEXT`, `CLOSE`, `DEALLOCATE`) were left raw.
*   **Files Modified:** [BodyConverter.cs](file:///e:/pg_converter_ui/BodyConverter.cs) (rewrites cursors to PL/pgSQL `FOR record IN SELECT ... LOOP`).
*   **Regression Tests Added:** `TestUnconvertedCursor` and `TestCURSOR`.
*   **PASS Improvement:** Resolved +5 Board, +1 Contact, and +50+ objects on scale.

### Rank 8: Transaction Control Keywords Stripping
*   **Root Cause:** `BEGIN TRAN`, `COMMIT TRAN`, and `ROLLBACK TRAN` keywords are illegal inside PL/pgSQL functions.
*   **Files Modified:** [BodyConverter.cs](file:///e:/pg_converter_ui/BodyConverter.cs) (removes transaction control words).
*   **Regression Tests Added:** `TestUnconvertedTransaction`.
*   **PASS Improvement:** Resolved +8 Contact procedures and +50+ objects on scale.

### Rank 9: Stripping Redundant Inner ORDER BY
*   **Root Cause:** PostgreSQL does not permit `ORDER BY` inside individual `UNION` query branches unless they are parenthesized.
*   **Files Modified:** [BodyConverter.cs](file:///e:/pg_converter_ui/BodyConverter.cs) (removes inner ORDER BY clauses that immediately precede UNION keywords).
*   **Regression Tests Added:** `TestUnionOrderBy`.
*   **PASS Improvement:** Fixed +4 Board procedures and +50+ objects on scale.

### Rank 10: XML OPENXML to XMLTABLE Translation
*   **Root Cause:** Proprietary MS SQL XML shredding procedures (`sp_xml_preparedocument`, `OPENXML`) caused compilation failures.
*   **Files Modified:** [BodyConverter.cs](file:///e:/pg_converter_ui/BodyConverter.cs) (strips doc handle creation and inserts `xmltable` stubs).
*   **Regression Tests Added:** `TestXMLOpenXML` and `TestXML`.
*   **PASS Improvement:** Fixed +2 Board, +1 Contact, and +3 objects on scale.

---

## 4. Remaining ROI Backlog

The following backlog details remaining issues sorted in descending order of Return on Investment (ROI):

| Rank | Priority | Expected PASS Increase | Complexity (1-10) | Risk | Files to Modify | Target Functions | Description |
|---|---|---|---|---|---|---|---|
| **1** | **Critical** | **+2,396** | 1 | Low | [MssqlDbReader.cs](file:///e:/pg_converter_ui/MssqlDbReader.cs) | `Load` / `sys.objects` query | **Procedure Misclassification Fix:** `sys.objects.type` contains space-padding `"P "`. Trim type column or match with padding. |
| **2** | **High** | **+1,248** | 5 | Low | [Converter.cs](file:///e:/pg_converter_ui/Converter.cs) | `ConvertView` / `ConvertConstraint` | **View & Constraint DDL:** Expand constraint stubs and map MSSQL check/default syntax to PG SQL constraints. |
| **3** | **High** | **+531** | 3 | Low | [MssqlDbReader.cs](file:///e:/pg_converter_ui/MssqlDbReader.cs) | `LoadIndexes` query | **Index Name Collision Bypass:** Loader checks global index names in schema, skipping valid index creation on other tables. |
| **4** | **Medium** | **+300** | 4 | Low | [Converter.cs](file:///e:/pg_converter_ui/Converter.cs) | `ConvertBody` / reserved word mapping | **Quote Identifiers in DML:** Columns matching reserved words (`desc`, `To`, `Left`) need quoting inside query bodies. |
| **5** | **Medium** | **+50** | 2 | Low | [Converter.cs](file:///e:/pg_converter_ui/Converter.cs) | `MapType` | **Datatype Mappings:** Support `sysname` -> `varchar(128)` and `datetimeoffset` -> `timestamp with time zone`. |

---

## 5. Regression Tests

The complete regression validation matrix is listed below:

| Test Case / Target | Purpose | Expected Result |
|---|---|---|
| `TestCarriageReturnDoubleSemicolon` | Verify lookbehinds match past carriage returns (`\r\n`). | No double semicolons `;;` appear in output. |
| `TestUnconvertedTransaction` | Verify transaction control blocks are removed. | Output contains no `TRAN` or `TRANSACTION`. |
| `TestGetDateParameterDefault` | Verify parameter defaults of `GETDATE` map to system date. | Output uses `CURRENT_DATE` or `now()`. |
| `TestParameterBlockComment` | Verify parameter comments do not corrupt param name. | Parameter parses successfully without UNPARSED tag. |
| `TestReservedWordPosition` | Verify keywords like `position` are wrapped in double quotes. | Output declares `"position"` with type definitions. |
| `TestUnconvertedCursor` | Verify cursor statements are converted to standard loops. | Output does not contain `OPEN`, `FETCH`, `DEALLOCATE`. |
| `TestUnionOrderBy` | Verify ORDER BY preceding UNION is stripped. | Redundant sort expressions are stripped inside subquery. |
| `TestXMLOpenXML` | Verify XML processing maps to stubs. | No `sp_xml_preparedocument` or `OPENXML` statements remain. |
| `TestCommentShieldingIfThen` | Verify THEN appears before the inline comment. | Output format is `IF condition THEN -- comment`. |
| `TestCommentShieldingWhileLoop` | Verify LOOP is inserted before trailing comments. | Output format is `WHILE condition LOOP -- comment`. |
| `TestUpdateSetAliasStrip` | Verify column aliases are stripped in UPDATE SET. | Output contains `SET col = val` instead of `SET alias.col = val`. |
| `TestDuplicateParamVarDeclarationFiltered` | Verify local variable declarations do not duplicate parameters. | local variable is omitted from local DECLARE block. |

---

## 6. Validation Process

*   **Lệnh QA Chuẩn Chính Thức (Official QA Validation Command):**
    Chạy script PowerShell sau để kiểm tra toàn bộ build và QA so với các baseline:
    ```powershell
    powershell -ExecutionPolicy Bypass -File scratch/run_post_commit_qa.ps1
    ```
*   **To run C# Unit Tests (NUnit) only:**
    ```powershell
    dotnet test e:\pg_converter_ui\tests\Regression\Regression.csproj
    ```
*   **To run Board Procedural QA Tests only:**
    ```powershell
    dotnet run --project e:\pg_converter_ui\qa\BoardRegressionTests\BoardRegressionTests.csproj
    ```
*   **To verify DDL build logs:**
    Review the validation logs generated under `reports/` following test execution.

---

## 7. Coding Rules

*   **Rules Followed during implementation:**
    1.  **Regex Timeout Guarding:** All replacement loops specify `RegexTimeout = TimeSpan.FromSeconds(5)` to prevent catastrophic backtracking.
    2.  **Line Normalization Early:** Standardize all carriage returns `\r\n` -> `\n` early in the pipeline (`BodyConverter.Convert`) to prevent formatting mismatches.
    3.  **Non-destructive Stubs:** Comment out unsupported MSSQL operations (Service Broker, CLR) with a descriptive `TODO` rather than omitting them silently.
*   **Rules Codex must continue:**
    1.  Always execute unit tests before committing modifications.
    2.  Do not permit local variables to conflict with input parameters.
    3.  Maintain compatibility checks for PostgreSQL 9.3 target limits (avoid using Postgres 9.5+ unique helper methods).
    4.  **Không được sửa trực tiếp SQL output; mọi sửa đổi phải thực hiện trong converter rồi sinh lại SQL.** (Do not edit generated SQL scripts directly. All modifications must be implemented inside the C# converter codebase to keep generated outputs consistent and reproducible).

---

## 8. Definition of Done

1.  **Build PASS:** `dotnet build` returns `0 Warning(s)`, `0 Error(s)`.
2.  **Regression PASS:** NUnit passes `26/26` tests.
3.  **Board QA PASS:** QA runner executes with success status for all `24/24` procedures.
4.  **No DDL Errors:** Converted outputs pass syntax compile checks on target PostgreSQL 9.3 database server.
