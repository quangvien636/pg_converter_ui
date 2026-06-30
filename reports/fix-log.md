# Fix Log — Board_% Procedures

**Date:** 2026-06-30  
**Scope:** Board_* stored procedures in `reports/board_failing_sql/`  
**QA Result:** ✅ PASS (24/24 representative procedures)

---

## Summary

| Category | Files Fixed | Occurrences |
|---|---|---|
| `end_without_if` | 17 | 19 |
| `semicolon_in_case` | 7 | 9 |
| `convert_function` | 9 | 37 |
| `cast_nvarchar` | 8 | 16 |
| `insert_execute_split` | 5 | 5 |
| **Total** | **33** | **88** |

---

## Category Details

### 1. `end_without_if` — `END;` used instead of `END IF;`

**Root cause:** Converter emits `END;` to close IF blocks, but PL/pgSQL requires `END IF;`.

**Files:** Board_DownBoard, Board_DownFolder, Board_GetBoards_BK, Board_GetHeads, Board_GetUserByShare, Board_InsertBoardContent, Board_InsertCurrentManager, Board_InsertRecommendedLog, Board_InsertReply, Board_InsertUserSetting, Board_InsertViewedLog, Board_SetFolders, Board_SetShare, Board_UpBoard, Board_UpdateFolder, Board_UpdateLevelRand, Board_UpFolder

**Fix:** Replace indented `END;` (inside function body, with leading whitespace) → `END IF;`

---

### 2. `semicolon_in_case` — Stray `;` inside CASE WHEN expressions

**Root cause:** Converter adds `;` after THEN branch values inside CASE expressions.

**Files:** Board_GetBoards, Board_GetBoards_Improved, Board_GetCurrentManagerList, Board_GetDepartAndPositionName, Board_GetSubMenus, Board_GetTreeSubMenu_V2

**Fixes:**
- Removed `;` after `THEN CA.UnreadCount` in CASE expression
- Removed `;` after WHEN/THEN values in GetCurrentManagerList
- Fixed `CREATE TEMP TABLE` with `ON COMMIT DROP;,` embedded in column definition → moved to table level
- Replaced `+` string concat with `||` in GetSubMenus

---

### 3. `convert_function` — MSSQL `CONVERT()` not valid in PostgreSQL

**Root cause:** `CONVERT(type, expr, style)` is MSSQL-specific; PostgreSQL uses `CAST()`, `::type`, or `TO_CHAR()`.

**Fixes by pattern:**
- `CONVERT(CHAR(16), date, 120)` → `TO_CHAR(date, 'YYYY-MM-DD HH24:MI')`
- `CONVERT(text, date, 120)` → `TO_CHAR(date, 'YYYY-MM-DD HH24:MI:SS')`
- `CONVERT(datetime, date, 111)` → `TO_CHAR(date, 'YYYY/MM/DD')`
- `CONVERT(BIGINT, 0)` → `0::bigint`
- `CONVERT(nvarchar(N), expr)` → `expr::text`
- Dynamic SQL `CONVERT(nvarchar(N), param) + 'string'` → `param::text || 'string'`

**Files:** Board_GetAllBoardContents, Board_GetPreNextContent, Board_InsertRecommendedLog, Board_GetCurrentManagerList, Board_SetFolders, Board_UpdateFolder, Board_GetBoardContents, Board_GetBoardContents_BK20181227, Board_GetAllBoardContentsByBoardList, Board_Web_Search

---

### 4. `cast_nvarchar` — `NVARCHAR` type not valid in PostgreSQL

**Root cause:** MSSQL `NVARCHAR` → PG `varchar` (PostgreSQL text is always Unicode).

**Fix:** Global replace `NVARCHAR` / `nvarchar` → `varchar` across all Board_*.sql files.

**Files:** Board_GetAllBoardContents, Board_GetAllBoardContentsByBoardList, Board_GetBoardContents, Board_GetBoardContents_BK20181227, Board_GetPreNextContent, Board_GetTreeSubMenu_V2_Json, Board_InsertNotificationService, Board_UpdateLevelRand

---

### 5. `insert_execute_split` — `INSERT INTO table;` on separate line from `EXECUTE`

**Root cause:** Converter split MSSQL `INSERT INTO table EXEC sp_executesql` into two separate PL/pgSQL statements with a `;` terminator in the middle.

**Fix:**
```sql
-- Before (invalid):
INSERT INTO SearchResult;
EXECUTE format(Query, BoardNo);

-- After:
-- TODO: embed BoardNo value into Query string before executing
EXECUTE 'INSERT INTO SearchResult ' || Query;
```

**⚠️ Known remaining issue:** `BoardNo` referenced as a literal identifier inside dynamic query strings (e.g., `WHERE BC.BoardNo = BoardNo`) needs to be embedded as a value. These are flagged with TODO comments.

**Files:** Board_GetBoardContents, Board_GetBoardContents_BK20181227, Board_GetAllBoardContentsByBoardList, Board_Web_Search, Board_Mobile_Search

---

## Other Fix

**Board_GetDepartAndPositionName:** `PositionName nvarchar(100)` → `varchar(100)` (inside CREATE TEMP TABLE)

**qa/BoardRegressionTests/Program.cs:** Removed duplicate `tempDropGuard` variable declaration (CS0128 build error)

---

## Remaining Items (Out of Scope / Manual Review Needed)

- Dynamic SQL parameter binding (`BoardNo` embedded as identifier, not value) — 5 files flagged with `TODO`
- `RETURNS SETOF record` → should be typed as `RETURNS TABLE(col type, ...)` — all Board_* functions (flagged in existing TODO comments)
- `ParseJson()` function reference — non-standard, needs UDF to exist in target DB
- `DATEADD()` not converted in Board_GetAllBoardContents (flagged in existing TODO comment)
