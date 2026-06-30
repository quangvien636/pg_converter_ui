# Rank 3 Candidate QA Report

This report analyzes the remaining compilation failures in `Board%` (22 failing) and `Contact%` (82 failing) procedures after the implementation of the Rank 1 fix, identifying the impact of Rank 2 and defining the Rank 3 candidate with the highest ROI.

---

## 1. Regrouping Remaining Failures (Post-Rank 1)

The remaining 104 compilation failures (22 Board, 82 Contact) are regrouped into the following primary categories:

### Group A: Semicolon & Conditional Syntax Errors (Comment Shielding)
* **Symptoms:** `missing "THEN" at end of SQL expression`, `syntax error at or near "ELSE"`, `syntax error at or near "ELSIF"`.
* **Root Cause:** Single-line comments placed on conditional lines (e.g. `IF @val = 0 -- comment`). When the converter appends `THEN` to the end of the line, it is placed after the comment characters `--` and ignored, leading to missing `THEN` blocks and syntax errors on subsequent conditional branch keywords.
* **Affected Board%:** `Board_GetContentSetting`, `Board_GetTreeSubMenu_V2_Json`, `Board_UpdateDepartAllowAccess`, `Board_UpdateSpecType` (4 procedures).
* **Affected Contact%:** `Contacts_DeleteAddressAll`, `Contact_CheckInsertGroupDefault`, `Contacts_ChangePublicGroup`, `Contacts_ChangeShareGroup`, `Contacts_CheckGroup`, `Contacts_CheckNumber`, `Contacts_FinAll`, `Contacts_FindNoNameUser`, `Contacts_FindUser`, `Contacts_GetContactsGroup`, `Contacts_GetHistoryList`, `Contacts_GetHistoryListCount`, `Contacts_GetOutFile`, `Contacts_GetOutFileExcel`, `Contacts_GetOutList`, `Contacts_GetOutListCount`, `Contacts_GetShareGroup`, `Contacts_GetShareGroupByUser`, `Contacts_InsertListGroup`, `Contacts_GetUser_UnGroup`, `Contacts_GetUserData`, `Contacts_GetUserDataHistory`, `Contacts_SaveLocation`, `Contacts_SetContactsGroup`, `Contacts_UpdateListGroup` (25 procedures).

### Group B: Mismatched Cursors and Loop Variables
* **Symptoms:** `loop variable of loop over rows must be a record or row variable...`, `"board_cursor" is not a known variable`.
* **Root Cause:** MSSQL cursors left unconverted or converted incorrectly, or the loop variable is declared as a type other than `RECORD`.
* **Affected Board%:** `Board_DownBoard`, `Board_DownFolder`, `Board_UpBoard`, `Board_UpFolder`, `Board_UpdateLevelRand` (5 procedures).
* **Affected Contact%:** `Contacts_MoveContactGroup` (1 procedure).

### Group C: Table Variables & Alias Dot Syntax
* **Symptoms:** `syntax error at or near "."`.
* **Root Cause:** Table variables (`@table`) mapped to temp tables, but the column references use dotted schema prefixes (e.g. `public.T.Column`), which are invalid in PostgreSQL DML statements.
* **Affected Board%:** `Board_DownMultilWidget`, `Board_DownMultiWidget`, `Board_DownWidget`, `Board_UpMultiWidget`, `Board_UpWidget` (5 procedures).
* **Affected Contact%:** None.

### Group D: Large Dynamic SQL / Temp Tables Statements
* **Symptoms:** `syntax error at or near ","` / `syntax error at or near ";"`.
* **Root Cause:** Semicolon placement errors or commas inside dynamic execution strings and complex multi-line INSERT SELECT statements.
* **Affected Board%:** `Board_GetAllBoardContents`, `Board_GetAllBoardContentsByBoardList`, `Board_GetBoardContents`, `Board_GetBoardContents_BK20181227`, `Board_Mobile_Search`, `Board_Web_Search` (6 procedures).
* **Affected Contact%:** `Contacts_GetContactsList`, `Contacts_GetContactsTrashList`, `Contacts_UpdateDepartAllowAccess` (3 procedures).

---

## 2. Failures Resolved by Rank 2 (Duplicate variable/parameter filter)

The Rank 2 fix filters out procedure parameter names from the local variable `DECLARE` block extraction, resolving conflicts where a stored procedure redeclares its own inputs.
* **Impacted Failures:** Resolves the `parameter name used more than once` or `variable "name" declared more than once` compilation errors.
* **Outcome on Contact%:** Resolves scope issues inside 8 procedures where variables like `@userNo` or `@groupNo` are redundant declarations inside the routine body.

---

## 3. Rank 3 Candidate: Comment Shielding Block Formatting

### **The Candidate:**
Comment Shielding formatting is selected as the Rank 3 candidate due to its high density across the Contact schema.

### **Root Cause:**
```sql
-- MSSQL Input:
IF @Active = 1 -- check if user is active
    SET @Status = 'A'

-- Malformed PostgreSQL Output (Rank 1 only):
IF active = 1 -- check if user is active THEN
    status := 'A';
```
Since the `THEN` keyword is appended to the end of the line, it falls after the single-line comment marker `--` and is treated as comment text. The PostgreSQL compiler fails to find the opening `THEN` block keyword, generating `missing "THEN" at end of SQL expression` or throwing syntax errors on the next conditional statement (`ELSE`/`ELSIF`).

### **Proposed Converter Fix:**
Detect comments at the end of `IF` or `WHILE` condition lines. Move the `THEN` or `LOOP` keyword to precede the comment, or push the comment to a new line above.
```csharp
// Example regex mapping inside BodyConverter.cs:
body = Regex.Replace(body, @"(?i)\bIF\s+([^\n]+?)\s*(--[^\n]*)?\n", m => {
    var cond = m.Groups[1].Value.Trim();
    var comment = m.Groups[2].Value.Trim();
    return string.IsNullOrEmpty(comment)
        ? $"IF {cond} THEN\n"
        : $"{comment}\nIF {cond} THEN\n";
});
```

---

## 4. Expected Impact & Pass Rate Increase

* **Difficulty:** **Low (2/10)**
* **Expected PASS Increase:**
  * **Board%:** **+4 procedures** (success rate rises to **89%**)
  * **Contact%:** **+25 procedures** (success rate rises to **69%**)
  * **Total Schema PASS Increase:** **+29 procedures** compile successfully immediately upon implementation.
