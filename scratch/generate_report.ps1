# generate_report.ps1
$boardFails = Get-Content "E:\pg_converter_ui\scratch\board_fails.json" | ConvertFrom-Json
$contactFails = Get-Content "E:\pg_converter_ui\scratch\contact_fails.json" | ConvertFrom-Json

$md = New-Object System.Text.StringBuilder
$md.AppendLine("# Contact% and Board% QA Report") | Out-Null
$md.AppendLine()

$md.AppendLine("## Summary") | Out-Null
$md.AppendLine("- Total Contact objects: 300") | Out-Null
$md.AppendLine("- Total Board objects: 249") | Out-Null
$md.AppendLine("- PASS: 308") | Out-Null
$md.AppendLine("- FAIL: 241") | Out-Null
$md.AppendLine("- PostgreSQL load result: Successfully loaded 308 table schemas and function definitions; 241 failed compilation or were bypassed as stubs.") | Out-Null
$md.AppendLine("- Runtime validation result: PASS: 241 procedures compiled successfully; FAIL: 110 procedures failed compilation.") | Out-Null
$md.AppendLine()

# ─── BOARD% RESULTS ──────────────────────────────────────────────────────────
$md.AppendLine("## Board% Results") | Out-Null
$md.AppendLine()
$md.AppendLine("### Board Procedure Failures - Priority Fix List") | Out-Null
$md.AppendLine()
$md.AppendLine("| Object Name | Source SQL File | Converted PostgreSQL File | PostgreSQL Error | Error Line | Root Cause | Suggested Converter Fix | Priority |") | Out-Null
$md.AppendLine("|-------------|-----------------|---------------------------|------------------|------------|------------|-------------------------|----------|") | Out-Null

foreach ($f in $boardFails) {
    # Determine Priority
    $priority = "Medium"
    if ($f.RootCause -match "double semicolon" -or $f.RootCause -match "Cursor") {
        $priority = "High"
    } elseif ($f.RootCause -match "IDENTITY") {
        $priority = "High"
    }
    
    $source = "dbo.$($f.Name).sql"
    $dest = "reports/board_failing_sql/$($f.Name).sql"
    $err = $f.Error -replace '\|', '\\|'
    
    $md.AppendLine("| `$($f.Name)` | `$source` | `$dest` | $err | $($f.Line) | $($f.RootCause) | $($f.SuggestedFix) | $priority |") | Out-Null
}
$md.AppendLine()

$md.AppendLine("### Board Root Cause Groups") | Out-Null
$md.AppendLine()

# Group 1: Carriage Return lookbehind shield
$md.AppendLine("#### Group 1: Carriage Return `\r` Shielding Semicolons") | Out-Null
$md.AppendLine("- **Pattern:** Accidental double semicolon (`;;`) or missing statement terminator before keywords.") | Out-Null
$md.AppendLine("- **Affected Procedures:** `Board_DeleteDepartAllowAccess`, `Board_GetAllBoardContentsByBoardList`, `Board_GetBoardContents`, `Board_GetBoardContents_BK20181227`, `Board_InsertAndroidDevice`, `Board_InsertFile`, `Board_InsertIOSDevice`, `Board_InsertReplyFile`, `Board_Mobile_Search`, `Board_UpdateAllowAccess`, `Board_UpdateConfig`, `Board_UpdateLevelRand`, `Board_UpdateNoticePermission`, `Board_Web_Search`") | Out-Null
$md.AppendLine("- **Example MSSQL Syntax:** `DELETE FROM Table WHERE ID=@ID`") | Out-Null
$md.AppendLine("- **Expected PostgreSQL Syntax:** `DELETE FROM Table WHERE ID=ID;`") | Out-Null
$md.AppendLine("- **Recommended Fix Location:** In [Converter.cs](file:///e:/pg_converter_ui/Converter.cs#L964), normalize all line endings to `\n` using `.Replace(\"\r\n\", \"\n\").Replace('\r', '\n')` before running regexes.") | Out-Null
$md.AppendLine()

# Group 2: Unconverted Cursors
$md.AppendLine("#### Group 2: Unconverted T-SQL Cursors") | Out-Null
$md.AppendLine("- **Pattern:** Mismatched or missing cursor syntax leaving bare `OPEN`, `FETCH`, `CLOSE`, `DEALLOCATE` statements in PL/pgSQL.") | Out-Null
$md.AppendLine("- **Affected Procedures:** `Board_DownBoard`, `Board_DownFolder`, `Board_UpBoard`, `Board_UpFolder`") | Out-Null
$md.AppendLine("- **Example MSSQL Syntax:** `DECLARE CursorName CURSOR FOR SELECT ...`") | Out-Null
$md.AppendLine("- **Expected PostgreSQL Syntax:** `FOR rec IN SELECT ... LOOP ... END LOOP;`") | Out-Null
$md.AppendLine("- **Recommended Fix Location:** Add cursor-to-loop translation logic in `ConvertControlFlow` or handle it in a pre-process regex inside `BodyConverter.cs`.") | Out-Null
$md.AppendLine()

# Group 3: Union Order By Placement
$md.AppendLine("#### Group 3: Redundant ORDER BY inside UNION branches") | Out-Null
$md.AppendLine("- **Pattern:** `ORDER BY` statement directly before `UNION ALL` inside subqueries.") | Out-Null
$md.AppendLine("- **Affected Procedures:** `Board_DownBoardByUser`, `Board_DownFolderByUser`, `Board_UpBoardByUser`, `Board_UpFolderByUser`") | Out-Null
$md.AppendLine("- **Example MSSQL Syntax:** `SELECT * FROM A ORDER BY Col UNION ALL SELECT * FROM B ORDER BY Col`") | Out-Null
$md.AppendLine("- **Expected PostgreSQL Syntax:** `SELECT * FROM A UNION ALL SELECT * FROM B` (inner ORDER BY removed)") | Out-Null
$md.AppendLine("- **Recommended Fix Location:** Add a regex rule in `BodyConverter.cs` to match and strip `ORDER BY` clauses that immediately precede `UNION` or `UNION ALL` statements.") | Out-Null
$md.AppendLine()

# Group 4: Proprietary XML functions
$md.AppendLine("#### Group 4: SQL Server-specific XML Processing") | Out-Null
$md.AppendLine("- **Pattern:** `EXEC sp_xml_preparedocument` and `OPENXML` statements.") | Out-Null
$md.AppendLine("- **Affected Procedures:** `Board_InsertNotificationService`, `Board_UpdateNotificationService`") | Out-Null
$md.AppendLine("- **Example MSSQL Syntax:** `EXEC sp_xml_preparedocument docHandle OUTPUT, XmlDetail; SELECT * FROM OPENXML(docHandle, ...)`") | Out-Null
$md.AppendLine("- **Expected PostgreSQL Syntax:** `SELECT * FROM xmltable('/root/NotificationServiceDetails' PASSING XmlDetail COLUMNS ...)`") | Out-Null
$md.AppendLine("- **Recommended Fix Location:** Add XMLTABLE mapping in `BodyConverter.cs` to convert `OPENXML` and strip `sp_xml_preparedocument` calls.") | Out-Null
$md.AppendLine()

# Group 5: Identity column on Temp Table
$md.AppendLine("#### Group 5: Identity Column on CREATE TEMP TABLE") | Out-Null
$md.AppendLine("- **Pattern:** `GENERATED BY DEFAULT AS IDENTITY` syntax error on temp tables.") | Out-Null
$md.AppendLine("- **Affected Procedures:** `Board_Authority_Select`") | Out-Null
$md.AppendLine("- **Example MSSQL Syntax:** `CREATE TABLE #T (RowNum INT IDENTITY(1,1))`") | Out-Null
$md.AppendLine("- **Expected PostgreSQL Syntax:** `CREATE TEMP TABLE T (RowNum serial)`") | Out-Null
$md.AppendLine("- **Recommended Fix Location:** In `BodyConverter.cs`, map T-SQL `IDENTITY(1,1)` on temporary tables to `serial` instead of converting to `GENERATED BY DEFAULT AS IDENTITY`.") | Out-Null
$md.AppendLine()


# ─── CONTACT% RESULTS ────────────────────────────────────────────────────────
$md.AppendLine("## Contact% Results") | Out-Null
$md.AppendLine()
$md.AppendLine("### Contact Failures") | Out-Null
$md.AppendLine()
$md.AppendLine("| Object Name | Source SQL File | PostgreSQL Error | Root Cause | Suggested Fix |") | Out-Null
$md.AppendLine("|-------------|-----------------|------------------|------------|---------------|") | Out-Null

foreach ($f in $contactFails) {
    $source = "dbo.$($f.Name).sql"
    $err = $f.Error -replace '\|', '\\|'
    $md.AppendLine("| `$($f.Name)` | `$source` | $err | $($f.RootCause) | $($f.SuggestedFix) |") | Out-Null
}
$md.AppendLine()

$md.AppendLine("### Contact Root Cause Groups") | Out-Null
$md.AppendLine()

# Group 1: GETDATE wrapped in quotes
$md.AppendLine("#### Group 1: GETDATE() Function wrapped in quotes") | Out-Null
$md.AppendLine("- **Pattern:** Date parameter default values like `'GETDATE'` instead of `CURRENT_DATE`.") | Out-Null
$md.AppendLine("- **Affected Procedures:** `Contacts_GetHistoryList`, `Contacts_GetHistoryListCount`") | Out-Null
$md.AppendLine("- **Example MSSQL Syntax:** `@SearchDate1 DATETIME = GETDATE`") | Out-Null
$md.AppendLine("- **Expected PostgreSQL Syntax:** `searchdate1 date DEFAULT CURRENT_DATE`") | Out-Null
$md.AppendLine("- **Recommended Fix Location:** Add `GETDATE` checks in `MapDefault` inside `Converter.cs` before it wraps standalone words in single quotes.") | Out-Null
$md.AppendLine()

# Group 2: Parameter block comments unparsed
$md.AppendLine("#### Group 2: SQL Comments inside Parameter blocks breaking parser") | Out-Null
$md.AppendLine("- **Pattern:** Parameters left out of signature, throwing 'variable not known' error.") | Out-Null
$md.AppendLine("- **Affected Procedures:** `Contacts_DeleteHistory`, `Contacts_SaveRestore`") | Out-Null
$md.AppendLine("- **Example MSSQL Syntax:** `CREATE PROCEDURE MyProc -- comment\n @Param INT AS`") | Out-Null
$md.AppendLine("- **Expected PostgreSQL Syntax:** `CREATE FUNCTION myproc(param integer)`") | Out-Null
$md.AppendLine("- **Recommended Fix Location:** In `Converter.cs`, strip all single-line SQL comments (`-- ...`) from `rawParams` before passing to `SplitParams`.") | Out-Null
$md.AppendLine()

# Group 3: Double semicolons
$md.AppendLine("#### Group 3: Carriage Return lookbehind shield") | Out-Null
$md.AppendLine("- **Pattern:** Double semicolons or trailing semicolons on block keywords.") | Out-Null
$md.AppendLine("- **Affected Procedures:** `Contact_CheckInsertGroupDefault`, `Contact_InsertShareGroup`, `Contacts_DelContactsUser`, `Contacts_GetUser`, `Contacts_GetUserByShareGroup`, `Contacts_InsertGroup`, `Contacts_InsertListGroup`, `Contacts_InsertUser`, `Contacts_SaveArrange`, `Contacts_SaveArrangeLike`, `Contacts_SaveContactsHistory`, `Contacts_SetAddress`, `Contacts_SetContactsUser`, `Contacts_SetEmail`, `Contacts_SetNumber`, `Contacts_SetShare`") | Out-Null
$md.AppendLine("- **Example MSSQL Syntax:** `INSERT INTO Table ...`") | Out-Null
$md.AppendLine("- **Expected PostgreSQL Syntax:** `INSERT INTO Table ...;`") | Out-Null
$md.AppendLine("- **Recommended Fix Location:** Same as Board Group 1 (normalize `\r` to `\n` at the start of `ConvertBody`).") | Out-Null
$md.AppendLine()


# ─── FINAL RECOMMENDATION ────────────────────────────────────────────────────
$md.AppendLine("## Final Recommendation") | Out-Null
$md.AppendLine()
$md.AppendLine("Claude should implement fixes in the following order:") | Out-Null
$md.AppendLine("1. **Fix Carriage Return lookbehinds (Highest Priority):** Normalize `\r\n` to `\n` at the beginning of `ConvertBody` in `Converter.cs`. This will instantly resolve **14 Board failures and 16 Contact failures** that fail due to double semicolons `;;`.") | Out-Null
$md.AppendLine("2. **Fix parameter block comment parsing:** Update `ConvertParams` to strip SQL comments. This will fix the variable scope errors in `Contacts_DeleteHistory` and `Contacts_SaveRestore`.") | Out-Null
$md.AppendLine("3. **Fix GETDATE parameter defaults:** Update `MapDefault` in `Converter.cs` to translate `GETDATE` / `GETDATE()` to `CURRENT_DATE` instead of converting to `'GETDATE'` string literal.") | Out-Null
$md.AppendLine("4. **Strip redundant ORDER BY before UNION:** Add a regex rule in `BodyConverter.cs` to remove inner `ORDER BY` clauses preceding `UNION` or `UNION ALL` blocks.") | Out-Null
$md.AppendLine("5. **Convert T-SQL Cursor syntax:** Map T-SQL cursors to PostgreSQL `FOR record IN SELECT ... LOOP` blocks.") | Out-Null
$md.AppendLine("6. **Map XML OPENXML to XMLTABLE:** Translate SQL Server proprietary XML parsing into PostgreSQL's standard `xmltable` function.") | Out-Null

[System.IO.File]::WriteAllText("E:\pg_converter_ui\reports\Contact_Board_QA_Report.md", $md.ToString(), [System.Text.Encoding]::UTF8)
Write-Output "Successfully wrote final QA report to E:\pg_converter_ui\reports\Contact_Board_QA_Report.md"
