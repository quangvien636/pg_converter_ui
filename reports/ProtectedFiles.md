# Protected Files Inventory

This document lists critical project files that must not be modified or restructured unless explicitly required, defining the rationale and regression risks.

---

## Protected Files List

### 1. `qa/BoardRegressionTests/Program.cs`
*   **Status:** **DO NOT MODIFY** (Appends of new regression assertions are allowed; existing checks must remain untouched).
*   **Reason:** This runner acts as the integration gatekeeper for the `Board%` stored procedures, containing 24 distinct assertions verifying keyword conversions, statement boundaries, CTE positioning, and temp table drop guards.
*   **Regression Risk:** High. Restructuring or disabling tests in this file runs a significant risk of letting database compile errors slip through unnoticed.

### 2. `tests/Regression/RegressionTests.cs`
*   **Status:** **DO NOT MODIFY** (Appends of new tests are permitted; existing tests must remain intact).
*   **Reason:** Holds the core NUnit unit tests for Rank 1 through Rank 10 converter features (carriage returns, duplicates, defaults, comments, cursors, order by, XML, update set alias, etc.).
*   **Regression Risk:** High. Modifying existing assertions can silence regression bugs.

### 3. `tests/Regression/UnsupportedFeaturesTests.cs`
*   **Status:** **DO NOT MODIFY** (Appends of new tests are permitted; existing tests must remain intact).
*   **Reason:** Verifies syntax rewrites for unsupported or partially supported MSSQL structures (TOP, OUTPUT, MERGE, RAISERROR, TRY/CATCH, cursors, table variables, CTEs, etc.).
*   **Regression Risk:** High.

### 4. `Logger.cs`
*   **Status:** **DO NOT MODIFY**
*   **Reason:** Implements thread-safe, daily-rotating text logging. It catches and ignores its own internal errors to prevent throwing unexpected exceptions and crashing the main WinForms UI or compiler runner threads.
*   **Regression Risk:** Medium (modifications could introduce thread contention or swallow critical debugging errors).

### 5. `Program.cs`
*   **Status:** **DO NOT MODIFY**
*   **Reason:** Delineates the application startup logic, UI execution context, global thread exceptions handler, and application lifecycle logs.
*   **Regression Risk:** High (errors could prevent execution startup on target machines).

### 6. `Models.cs`
*   **Status:** **DO NOT MODIFY**
*   **Reason:** Defines the central record entities (`DbObject`, `ColumnInfo`, `ObjectType` enum) used to pass schemas throughout all phases of catalog loading, parsing, and DDL script generation.
*   **Regression Risk:** Critical (modifications will trigger compilation failures across all other modules).
