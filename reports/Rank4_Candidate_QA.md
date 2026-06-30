# Rank 4 Candidate QA Report

This report analyzes the remaining compilation failures and proposes the highest ROI candidate for the Rank 4 fix.

---

## 1. Focused Analysis of Remaining Failures

### 1. Table Alias Dot Prefix in UPDATE Statements
* **The Issue:** PostgreSQL does not allow table name or alias qualifiers on target columns in the `SET` clause of an `UPDATE` statement.
* **T-SQL Example:**
  ```sql
  UPDATE BW SET BW.Sort = 1, BW.ModUserNo = 2
  FROM Board_MultiBoardWidget BW;
  ```
* **PostgreSQL Failure:** `syntax error at or near "."`
* **PostgreSQL Equivalent:**
  ```sql
  UPDATE Board_MultiBoardWidget AS BW SET Sort = 1, ModUserNo = 2
  FROM Board_MultiBoardWidget;
  ```
* **Converter Fix:** Strip table alias prefixes (e.g. `BW.`) from variables inside the `SET` clause of `UPDATE` statements.
* **Affected Board Count:** 5 (`Board_DownMultilWidget`, `Board_DownMultiWidget`, `Board_DownWidget`, `Board_UpMultiWidget`, `Board_UpWidget`).
* **Affected Contact Count:** 0
* **Difficulty:** **Low (2/10)**

---

### 2. ORDER BY before UNION ALL
* **The Issue:** PostgreSQL throws syntax errors when `ORDER BY` is included inside subquery union branches before the final union member.
* **T-SQL Example:**
  ```sql
  SELECT A FROM B ORDER BY A DESC
  UNION ALL
  SELECT A FROM C ORDER BY A DESC;
  ```
* **PostgreSQL Failure:** `syntax error at or near "UNION"`
* **PostgreSQL Equivalent:**
  ```sql
  SELECT A FROM B
  UNION ALL
  SELECT A FROM C ORDER BY A DESC;
  ```
* **Converter Fix:** Strip `ORDER BY` clauses that immediately precede `UNION` or `UNION ALL` statements.
* **Affected Board Count:** 4 (`Board_DownBoardByUser`, `Board_DownFolderByUser`, `Board_UpBoardByUser`, `Board_UpFolderByUser`).
* **Affected Contact Count:** 0
* **Difficulty:** **Low (2/10)**

---

### 3. Cursors & Loop Variable Translation
* **The Issue:** Bare cursor commands (`OPEN`, `FETCH`, `CLOSE`, `DEALLOCATE`) are invalid in PL/pgSQL; they must be rewritten to record loop statements.
* **T-SQL Example:**
  ```sql
  DECLARE my_cursor CURSOR FOR SELECT No FROM Tab;
  OPEN my_cursor;
  FETCH NEXT FROM my_cursor INTO @no;
  ```
* **PostgreSQL Failure:** `loop variable of loop over rows must be a record...`
* **PostgreSQL Equivalent:**
  ```sql
  FOR rec IN SELECT No FROM Tab LOOP
      no := rec.No;
      -- loop body
  END LOOP;
  ```
* **Affected Board Count:** 5 (`Board_DownBoard`, `Board_DownFolder`, `Board_UpBoard`, `Board_UpFolder`, `Board_UpdateLevelRand`).
* **Affected Contact Count:** 1 (`Contacts_MoveContactGroup`).
* **Difficulty:** **Medium (5/10)**

---

## 2. Recommended Rank 4 Candidate: Strip Target Table Aliases

### **The Candidate:**
Stripping the target table name/alias prefix in `UPDATE SET` statements is selected as the Rank 4 fix candidate.

### **ROI Rationale:**
It has the absolute highest ROI of all remaining items:
* **Difficulty:** **Very Low (1/10)**. A single regex replacement in `BodyConverter.cs` (or `Converter.cs`) can remove all `Alias.Column` prefixes from `SET` assignments.
* **Expected PASS Increase:** **+5 Board procedures** compile successfully immediately upon implementation.
* **Converter Implementation:**
  ```csharp
  // Locate the UPDATE block and remove "Alias." from the left-hand side of assignments
  body = Regex.Replace(body, @"(?i)\bSET\s+([a-zA-Z0-9_]+\.[a-zA-Z0-9_]+)\s*=", m => {
      var parts = m.Groups[1].Value.Split('.');
      return $"SET {parts[1]} =";
  });
  ```
