# Rank 5 Candidate QA Report

This report evaluates potential candidates for the Rank 5 fix, ranking them by ROI (Return on Investment) and outlining their exact affected procedures, estimated pass increases, complexity, risk, recommended functions, and required regression tests.

---

## 1. Candidate Evaluation Matrix

| Candidate | Affected Procedures | Est. PASS Increase | Complexity | Risk | Recommended File/Function |
|---|---|---|---|---|---|
| **1. ORDER BY before UNION ALL** | **Board (4):**<br>- `Board_DownBoardByUser`<br>- `Board_DownFolderByUser`<br>- `Board_UpBoardByUser`<br>- `Board_UpFolderByUser` | **+4 Board** | **Low (2/10)** | **Low** | `Converter.cs` / `ConvertBody` |
| **2. Cursor Translation** | **Board (5):**<br>- `Board_DownBoard`<br>- `Board_DownFolder`<br>- `Board_UpBoard`<br>- `Board_UpFolder`<br>- `Board_UpdateLevelRand`<br>**Contact (1):**<br>- `Contacts_MoveContactGroup` | **+5 Board**<br>**+1 Contact** | **Medium (5/10)**| **Medium** | `BodyConverter.cs` / `ConvertCursors` |
| **3. Dynamic SQL Semicolon / Spacing** | **Board (6):**<br>- `Board_GetAllBoardContents`<br>- `Board_GetAllBoardContentsByBoardList`<br>- `Board_GetBoardContents`<br>- `Board_GetBoardContents_BK20181227`<br>- `Board_Mobile_Search`<br>- `Board_Web_Search`<br>**Contact (3):**<br>- `Contacts_GetContactsList`<br>- `Contacts_GetContactsTrashList`<br>- `Contacts_UpdateDepartAllowAccess` | **+6 Board**<br>**+3 Contact** | **Medium (6/10)**| **Medium** | `BodyConverter.cs` / `ConvertExec` |
| **4. Table Variables with Dot Aliases** | Handled in Rank 4 / table variables mapping. | N/A | Low (2/10) | Low | `BodyConverter.cs` / `ConvertTempTables` |

---

## 2. Detailed Candidate Review & Regression Tests

### **Candidate 1: ORDER BY before UNION ALL (Recommended Rank 5)**
* **Rationale:** This candidate offers the highest ROI due to its low complexity and zero regression risk. Stripping redundant subquery `ORDER BY` sorting instructions immediately preceding a `UNION` or `UNION ALL` statement has no semantic impact on the query outcome in PostgreSQL.
* **Exact Example:**
  ```sql
  -- MSSQL:
  SELECT A FROM B ORDER BY A DESC UNION ALL SELECT A FROM C ORDER BY A DESC;
  -- PostgreSQL Equivalent:
  SELECT A FROM B UNION ALL SELECT A FROM C ORDER BY A DESC;
  ```
* **Recommended Implementation:**
  Add a regex rule in `Converter.cs` inside `ConvertBody`:
  ```csharp
  body = Regex.Replace(body, @"\bORDER\s+BY\s+(?:[^;()\n])+?(?=\s+UNION\b)", "", RegexOptions.IgnoreCase);
  ```
* **Minimal Regression Test Case:**
  ```csharp
  [Test]
  public void TestUnionOrderBy()
  {
      string mssql = "CREATE PROCEDURE dbo.TestUnion AS BEGIN SELECT X FROM Y ORDER BY X UNION ALL SELECT X FROM Z; END";
      var obj = new DbObject("testunion", ObjectType.Procedure, mssql, false, "OK");
      string pg = Converter.Convert(obj, "postgres");
      Assert.That(pg, Does.Not.Contain("ORDER BY X UNION"));
  }
  ```

---

### **Candidate 2: Cursor Translation**
* **Rationale:** Necessary for core structural routines, but requires more extensive state-tracking regexes to convert cursor open/fetch/close commands to loop structures.
* **Exact Example:**
  ```sql
  -- MSSQL:
  DECLARE c CURSOR FOR SELECT X FROM Y; OPEN c; FETCH NEXT FROM c INTO @v;
  -- PostgreSQL Equivalent:
  FOR rec IN SELECT X FROM Y LOOP v := rec.X; ... END LOOP;
  ```
* **Recommended Implementation:** `BodyConverter.cs` -> `ConvertCursors`.
* **Minimal Regression Test Case:**
  Verify that `OPEN cursor_name` and `FETCH NEXT` blocks are converted to PL/pgSQL `FOR record IN SELECT ... LOOP` blocks.

---

### **Candidate 3: Dynamic SQL Semicolon & Spacing**
* **Rationale:** Resolves syntax failures in large procedures mapping `sp_executesql`, but is more prone to spacing edge cases when variables are concatenated inside string queries.
* **Exact Example:**
  ```sql
  -- MSSQL:
  EXEC sp_executesql @stmt, N'@param INT', @param = 1
  -- PostgreSQL Equivalent:
  EXECUTE stmt USING param;
  ```
* **Recommended Implementation:** `BodyConverter.cs` -> `ConvertExec`.
* **Minimal Regression Test Case:**
  Verify that parameter definitions are mapped to `USING` clauses of the `EXECUTE` statement.
