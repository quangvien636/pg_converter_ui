# Converter Rules Reference

This report defines the transformation rules implemented by the database converter to map MS SQL functions and constructs to PostgreSQL.

---

## Implemented Conversions

### 1. `TOP` Clause Mapping
*   **Input T-SQL:**
    ```sql
    SELECT TOP 10 Col FROM Tab
    ```
*   **Output PL/pgSQL:**
    ```sql
    SELECT Col FROM Tab LIMIT 10
    ```
*   **Converter Function:**
    *   `pg_converter_ui.Converter.ConvertBody` maps single-line select queries:
        ```csharp
        body = Regex.Replace(body, @"(?im)^([ \t]*(?:RETURN\s+QUERY\s+)?SELECT\s+)TOP\s*\(?\s*(\d+)\s*\)?\s*([^\n]+?)(\s*;?)[ \t]*$", "$1$3 LIMIT $2$4");
        ```
    *   `pg_converter_ui.BodyConverter.NormalizeBoardTop` removes or comments it in complex subqueries.
*   **Regression Test:** `UnsupportedFeaturesTests.TestTOP` (NUnit).

### 2. `ISNULL` Function Mapping
*   **Input T-SQL:**
    ```sql
    ISNULL(Name, '')
    ```
*   **Output PL/pgSQL:**
    ```sql
    COALESCE(Name, '')
    ```
*   **Converter Function:**
    *   `pg_converter_ui.Converter.ConvertBody` and `ConvertView`:
        ```csharp
        body = Regex.Replace(body, @"\bISNULL\s*\(", "COALESCE(", RegexOptions.IgnoreCase);
        ```
*   **Regression Test:** Verified implicitly in `RegressionTests.TestCommentShieldingIfThen` and QA check `ID-016` (Scalar body mapping).

### 3. `GETDATE` Date Mapping
*   **Input T-SQL:**
    *   Routine Body: `GETDATE()`
    *   Parameter Default: `@Date DATE = GETDATE`
*   **Output PL/pgSQL:**
    *   Routine Body: `NOW()`
    *   Parameter Default: `date DEFAULT CURRENT_DATE`
*   **Converter Function:**
    *   `pg_converter_ui.Converter.ConvertBody` for bodies:
        ```csharp
        body = Regex.Replace(body, @"\bGETDATE\s*\(\s*\)", "NOW()", RegexOptions.IgnoreCase);
        ```
    *   `pg_converter_ui.Converter.MapDefault` for parameter signatures.
*   **Regression Test:** `RegressionTests.TestGetDateParameterDefault` (NUnit) and QA check `ID-007`.

### 4. `TRY / CATCH` Block Mapping
*   **Input T-SQL:**
    ```sql
    BEGIN TRY
        UPDATE Tab SET A = 1;
    END TRY
    BEGIN CATCH
        ROLLBACK TRAN;
    END CATCH
    ```
*   **Output PL/pgSQL:**
    ```sql
    UPDATE Tab SET A = 1;
    EXCEPTION WHEN OTHERS THEN
        NULL; -- Redundant transaction control stripped
    ```
*   **Converter Function:**
    *   `pg_converter_ui.BodyConverter.ConvertTryCatch`:
        ```csharp
        body = SafeReplace(body, "TryCatch", @"BEGIN\s+TRY\s*([\s\S]+?)\s*END\s+TRY\s+BEGIN\s+CATCH\s*([\s\S]*?)\s*END\s+CATCH\b", ...);
        ```
*   **Regression Test:** `UnsupportedFeaturesTests.TestTRY_CATCH` (NUnit).

### 5. `OUTPUT` Clause & Parameters
*   **Input T-SQL:**
    *   Routine Body: `INSERT INTO Tab (Col) OUTPUT inserted.Id VALUES (1)`
    *   Parameter DDL: `@NewId INT OUTPUT`
*   **Output PL/pgSQL:**
    *   Routine Body: `INSERT INTO Tab (Col) VALUES (1) RETURNING Id`
    *   Parameter DDL: `INOUT newid integer`
*   **Converter Function:**
    *   `pg_converter_ui.Converter.ConvertParams` converts the parameter signature mapping `OUTPUT` to `INOUT`.
    *   `pg_converter_ui.BodyConverter.Convert` handles standard body clauses.
*   **Regression Test:** `UnsupportedFeaturesTests.TestOUTPUT` (NUnit) and QA checks `ID-011` / `ID-012`.

---

## Unimplemented / Backlog Conversions

### 1. `LEN` String Length
*   **Input T-SQL:** `LEN(Col)`
*   **Expected PostgreSQL:** `LENGTH(Col)` or `CHAR_LENGTH(Col)`
*   **Converter Status:** **Unimplemented**. Currently emitted as `LEN(Col)`, failing compilation on PostgreSQL.
*   **Recommended Implementation:**
    ```csharp
    body = Regex.Replace(body, @"\bLEN\s*\(", "LENGTH(", RegexOptions.IgnoreCase);
    ```

### 2. `DATEADD` Date Arithmetic
*   **Input T-SQL:** `DATEADD(dd, days, date_val)`
*   **Expected PostgreSQL:** `date_val + interval '1 day' * days`
*   **Converter Status:** **Unimplemented** (flagged as manual rewrite requirement `TODO: DATEADD()`).
*   **Recommended Implementation:** Add regex pattern mappings to match standard interval symbols (`dd`/`day`/`d`, `mm`/`month`/`m`, `yy`/`year`/`y`) inside `BodyConverter.cs`.
