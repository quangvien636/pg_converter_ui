# Board & Contact Root Cause Priority Report

This report classifies the root causes of PostgreSQL procedure compilation failures across the `Board%` and `Contact%` modules, sorted by Return on Investment (ROI) to help guide implementation.

---

## Root Cause Priority Matrix

| Rank | Root Cause | Affected Procedures (Est.) | Converter Source File | Exact Function to Modify | Expected Impact | ROI |
|------|------------|---------------------------|-----------------------|--------------------------|-----------------|-----|
| 1 | Carriage Return `\r` Semicolon Shielding | 30+ | `Converter.cs` | `Convert` / `ConvertBody` | Resolves all double semicolon `;;` and missing statement terminator errors. | **Highest (10/10)** |
| 2 | Unconverted Transaction Statements (`TRAN`) | 8+ | `BodyConverter.cs` | `ConvertBody` | Removes illegal `BEGIN TRAN`, `COMMIT TRAN`, `ROLLBACK TRAN` statements. | **High (9/10)** |
| 3 | GETDATE Parameter Default Wrapped in Quotes | 4+ | `Converter.cs` | `MapDefault` | Resolves parameter date default mismatch (`'GETDATE'` -> `CURRENT_DATE`). | **High (8/10)** |
| 4 | SQL Comments in Parameter Block | 3+ | `Converter.cs` | `ConvertParams` | Ensures parameters are parsed properly and not ignored as unparsed comments. | **High (8/10)** |
| 5 | Reserved Word `position` Unquoted | 4+ | `Converter.cs` | `PgReservedWords` hashset | Resolves syntax errors when utilizing reserved keyword `position` as parameter. | **High (8/10)** |
| 6 | Unconverted T-SQL Cursors | 9+ | `BodyConverter.cs` | `ConvertBody` / `ConvertControlFlow` | Resolves syntax errors on bare `OPEN`, `FETCH`, `CLOSE`, `DEALLOCATE` statements. | **Medium (6/10)** |
| 7 | Redundant ORDER BY inside UNION branches | 8+ | `BodyConverter.cs` | `ConvertBody` | Removes inner ORDER BY clauses that PostgreSQL rejects inside UNION queries. | **Medium (6/10)** |
| 8 | SQL Server Proprietary XML Functions | 2 | `BodyConverter.cs` | `ConvertBody` | Converts `OPENXML` and `sp_xml_preparedocument` to PostgreSQL `XMLTABLE`. | **Medium (5/10)** |

---

## Detailed Root Cause Analysis

### 1. Carriage Return `\r` Semicolon Shielding
* **Number of Affected Procedures:** 30+ (e.g., `Board_DeleteDepartAllowAccess`, `Contact_CheckInsertGroupDefault`, `Contacts_SetEmail`)
* **Converter Source File:** [Converter.cs](file:///e:/pg_converter_ui/Converter.cs)
* **Exact Function:** `Convert` or start of `ConvertBody`.
* **Description:** In Windows files, lines end with `\r\n`. The statement boundary check regex uses negative lookbehind `(?<![;,])` which checks the last character. Because the line ending has `\r`, the regex evaluates `\r` instead of the trailing semicolon `;`. It then appends a second semicolon, resulting in double semicolons `;;` which breaks PostgreSQL compilation.
* **Suggested Fix:** At the entry point of body conversion, normalize all line endings to `\n`:
  ```csharp
  body = body.Replace("\r\n", "\n").Replace('\r', '\n');
  ```

---

### 2. Unconverted Transaction Statements (`TRAN`)
* **Number of Affected Procedures:** 8+ (e.g., `Contacts_MoveUser`, `Contacts_SaveAddressInfo`, `Contacts_SaveAddressInfo_Web`)
* **Converter Source File:** [BodyConverter.cs](file:///e:/pg_converter_ui/BodyConverter.cs)
* **Exact Function:** `ConvertBody`
* **Description:** PostgreSQL PL/pgSQL functions do not support transaction statement control keywords (`BEGIN TRAN`, `COMMIT TRAN`, `ROLLBACK TRAN`) inside function blocks, causing `syntax error at or near "TRAN"`.
* **Suggested Fix:** Since PL/pgSQL functions run inside an implicit database transaction, transaction controls are completely redundant and can be stripped:
  ```csharp
  body = Regex.Replace(body, @"\b(?:BEGIN|COMMIT|ROLLBACK)\s+(?:TRAN|TRANSACTION)\b;?", "", RegexOptions.IgnoreCase);
  ```

---

### 3. GETDATE Parameter Default Wrapped in Quotes
* **Number of Affected Procedures:** 4+ (e.g., `Contacts_GetHistoryList`, `Contacts_GetHistoryListCount`)
* **Converter Source File:** [Converter.cs](file:///e:/pg_converter_ui/Converter.cs#L929)
* **Exact Function:** `MapDefault`
* **Description:** When parameter defaults are parsed, a single word like `GETDATE` is matched by `^[A-Za-z_]\w*$` and wrapped in quotes to become `'GETDATE'`. PostgreSQL fails to compile this as a date.
* **Suggested Fix:** Add a specific check to convert date function calls to `CURRENT_DATE`:
  ```csharp
  if (def.Equals("GETDATE", StringComparison.OrdinalIgnoreCase) || def.Equals("GETDATE()", StringComparison.OrdinalIgnoreCase))
      return "CURRENT_DATE";
  ```

---

### 4. SQL Comments in Parameter Block
* **Number of Affected Procedures:** 3+ (e.g., `Contacts_DeleteHistory`, `Contacts_SaveRestore`)
* **Converter Source File:** [Converter.cs](file:///e:/pg_converter_ui/Converter.cs#L870)
* **Exact Function:** `ConvertParams`
* **Description:** If a comment (e.g., `-- comment`) is present inside the T-SQL parameter block, `SplitParams` passes it along with the parameter name. The parameter matching regex fails, outputting the parameter as an `-- UNPARSED:` comment, which leaves the parameter undeclared and leads to `not a known variable` compiler exceptions.
* **Suggested Fix:** Strip single-line and block comments from `rawParams` before splitting:
  ```csharp
  rawParams = Regex.Replace(rawParams, @"(?m)--[^\r\n]*", "");
  rawParams = Regex.Replace(rawParams, @"/\*[\s\S]*?\*/", "");
  ```

---

### 5. Reserved Word `position` Unquoted
* **Number of Affected Procedures:** 4+ (e.g., `Contacts_MoveContactGroup`, `Contacts_InsertUserForExcel`)
* **Converter Source File:** [Converter.cs](file:///e:/pg_converter_ui/Converter.cs#L9)
* **Exact Function:** `PgReservedWords` Hashset definition.
* **Description:** `position` is a SQL standard reserved function keyword in PostgreSQL. Declaring or calling it without double quotes results in syntax errors.
* **Suggested Fix:** Simply add `"position"` to the `PgReservedWords` hashset to wrap it in double quotes automatically.

---

### 6. Unconverted T-SQL Cursors
* **Number of Affected Procedures:** 9+ (e.g., `Board_DownBoard`, `Board_DownFolder`, `Contacts_MoveContactGroup`)
* **Converter Source File:** [BodyConverter.cs](file:///e:/pg_converter_ui/BodyConverter.cs)
* **Exact Function:** `ConvertBody`
* **Description:** The converter strips T-SQL `DECLARE CursorName CURSOR FOR` declarations but leaves the cursor loop statements (`OPEN`, `FETCH`, `CLOSE`, `DEALLOCATE`) untouched, causing compilation failures.
* **Suggested Fix:** Rewrite the cursor block into a simple PostgreSQL loop:
  ```sql
  FOR record_var IN SELECT ... LOOP
      -- loop body
  END LOOP;
  ```

---

### 7. Redundant ORDER BY inside UNION branches
* **Number of Affected Procedures:** 8+ (e.g., `Board_DownBoardByUser`, `Board_DownFolderByUser`, `Board_UpBoardByUser`, `Board_UpFolderByUser`)
* **Converter Source File:** [BodyConverter.cs](file:///e:/pg_converter_ui/BodyConverter.cs)
* **Exact Function:** `ConvertBody`
* **Description:** PostgreSQL syntax does not permit `ORDER BY` inside individual `UNION` query branches unless they are parenthesized. Because the main query is sorted at the end, these inner sorting instructions are redundant.
* **Suggested Fix:** Add a regex rule to strip inner `ORDER BY` clauses directly preceding `UNION ALL` or `UNION` keywords.

---

### 8. SQL Server Proprietary XML Functions
* **Number of Affected Procedures:** 2 (`Board_InsertNotificationService`, `Board_UpdateNotificationService`)
* **Converter Source File:** [BodyConverter.cs](file:///e:/pg_converter_ui/BodyConverter.cs)
* **Exact Function:** `ConvertBody`
* **Description:** Uses proprietary T-SQL `sp_xml_preparedocument` and `OPENXML` procedures which have no PostgreSQL equivalents.
* **Suggested Fix:** Map `OPENXML` statements to standard PostgreSQL `XMLTABLE(...)` query blocks.
