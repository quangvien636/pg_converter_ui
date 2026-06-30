# Runtime Validation Report

**Generated**: 2026-06-29 14:36:25  
**SQL file** : `all-converted.sql`  
**Database** : `pg_converter_runtime_test` @ `221.148.141.4:5432` (PostgreSQL 15.7)  

## 1. Summary

| Metric | Value |
|--------|-------|
| Total statements executed | **5,815** |
| Statements succeeded | **4,405** |
| Statements failed | **1,410** |
| Success rate | **76%** |
| Distinct error codes (SqlState) | 8 |

## 2. Error Count by Category

| SqlState | Category | Count | First Failing Object (Type) |
|----------|----------|------:|------------------------------|
| `42601` | syntax_error | 1358 | `Note_Comments` (TABLE) |
| `22007` | invalid_datetime_format | 16 | `WorkGroupHistorys` (TABLE) |
| `42830` | class_42 | 13 | `FK_EAPPDocument_EAPPHistory` (CONSTRAINT) |
| `42P01` | undefined_table | 8 | `EDMSMainList` (VIEW) |
| `42P13` | invalid_function_definition | 6 | `Contacts_GetChildGroupByGroupNo` (FUNCTION) |
| `42804` | datatype_mismatch | 4 | `Note_SendNote` (PROCEDURE) |
| `22P02` | invalid_text_representation | 3 | `SurveyPoll` (TABLE) |
| `42704` | class_42 | 2 | `parseJSON` (FUNCTION) |

## 3. Top 30 PostgreSQL Errors

### #1 — 1159 occurrences

| Field | Value |
|-------|-------|
| Error key | `[42601] syntax error at or near "<name>"` |
| First object | `Note_Comments` (TABLE) |
| Example message | syntax error at or near "[" |

### #2 — 84 occurrences

| Field | Value |
|-------|-------|
| Error key | `[42601] missing "<name>" at end of SQL expression` |
| First object | `ChangeTimeOffset` (FUNCTION) |
| Example message | missing "THEN" at end of SQL expression |

### #3 — 64 occurrences

| Field | Value |
|-------|-------|
| Error key | `[42601] "<name>" is not a known variable` |
| First object | `Board_DeleteReply` (PROCEDURE) |
| Example message | "contentno" is not a known variable |

### #4 — 24 occurrences

| Field | Value |
|-------|-------|
| Error key | `[42601] syntax error at end of input` |
| First object | `Contacts_DelContactsGroup` (PROCEDURE) |
| Example message | syntax error at end of input |

### #5 — 15 occurrences

| Field | Value |
|-------|-------|
| Error key | `[42601] mismatched parentheses at or near "<name>"` |
| First object | `Center_GetAccessLog` (PROCEDURE) |
| Example message | mismatched parentheses at or near ";" |

### #6 — 13 occurrences

| Field | Value |
|-------|-------|
| Error key | `[42830] there is no unique constraint matching given keys for referenced table "<name>"` |
| First object | `FK_EAPPDocument_EAPPHistory` (CONSTRAINT) |
| Example message | there is no unique constraint matching given keys for referenced table "EAPPHistory" |

### #7 — 9 occurrences

| Field | Value |
|-------|-------|
| Error key | `[22007] invalid input syntax for type timestamp: "<name>"` |
| First object | `Note_AddAndUpdateComments` (PROCEDURE) |
| Example message | invalid input syntax for type timestamp: "GETUTCDATE" |

### #8 — 8 occurrences

| Field | Value |
|-------|-------|
| Error key | `[42P01] relation "<name>" does not exist` |
| First object | `EDMSMainList` (VIEW) |
| Example message | relation "public.edmsdocument" does not exist |

### #9 — 7 occurrences

| Field | Value |
|-------|-------|
| Error key | `[22007] invalid input syntax for type date: "<name>"` |
| First object | `WorkGroupHistorys` (TABLE) |
| Example message | invalid input syntax for type date: "" |

### #10 — 6 occurrences

| Field | Value |
|-------|-------|
| Error key | `[42601] loop variable of loop over rows must be a record or row variable or list of scalar variables` |
| First object | `NoticeSyn_DownDivisions` (PROCEDURE) |
| Example message | loop variable of loop over rows must be a record or row variable or list of scalar variables |

### #11 — 6 occurrences

| Field | Value |
|-------|-------|
| Error key | `[42601] INTO specified more than once at or near "<name>"` |
| First object | `NoticeSyn_GetNotices` (PROCEDURE) |
| Example message | INTO specified more than once at or near "INTO" |

### #12 — 5 occurrences

| Field | Value |
|-------|-------|
| Error key | `[42P13] parameter name "<name>" used more than once` |
| First object | `Contacts_GetChildGroupByGroupNo` (FUNCTION) |
| Example message | parameter name "groupno" used more than once |

### #13 — 3 occurrences

| Field | Value |
|-------|-------|
| Error key | `[22P02] invalid input syntax for integer: "<name>"` |
| First object | `SurveyPoll` (TABLE) |
| Example message | invalid input syntax for integer: "" |

### #14 — 3 occurrences

| Field | Value |
|-------|-------|
| Error key | `[42804] argument of DEFAULT must be type boolean, not type integer` |
| First object | `Note_SendNote` (PROCEDURE) |
| Example message | argument of DEFAULT must be type boolean, not type integer |

### #15 — 1 occurrences

| Field | Value |
|-------|-------|
| Error key | `[42704] type you does not exist` |
| First object | `parseJSON` (FUNCTION) |
| Example message | type you does not exist |

### #16 — 1 occurrences

| Field | Value |
|-------|-------|
| Error key | `[42704] type "<name>" does not exist` |
| First object | `EAPPProgressOpionUpdate` (PROCEDURE) |
| Example message | type "binary" does not exist |

### #17 — 1 occurrences

| Field | Value |
|-------|-------|
| Error key | `[42P13] function result type must be character varying because of OUT parameters` |
| First object | `EDMS_GetGroupNM` (PROCEDURE) |
| Example message | function result type must be character varying because of OUT parameters |

### #18 — 1 occurrences

| Field | Value |
|-------|-------|
| Error key | `[42804] RETURN cannot have a parameter in function returning set` |
| First object | `sp_upgraddiagrams` (PROCEDURE) |
| Example message | RETURN cannot have a parameter in function returning set |
| Hint | Use RETURN NEXT or RETURN QUERY. |

## 4. Object Type Breakdown

| Object Type | Statements | Succeeded | Failed | Success Rate |
|-------------|----------:|----------:|-------:|-------------:|
| PROCEDURE | 4792 | 3515 | 1277 | 73% |
| TABLE | 670 | 667 | 3 | 100% |
| FUNCTION | 240 | 131 | 109 | 55% |
| INDEX | 84 | 84 | 0 | 100% |
| VIEW | 16 | 8 | 8 | 50% |
| CONSTRAINT | 13 | 0 | 13 | 0% |

## 5. First Failing Object per Error Category

| SqlState | Category | Object | Type | Message |
|----------|----------|--------|------|---------|
| `42601` | syntax_error | `Note_Comments` | TABLE | syntax error at or near "[" |
| `22007` | invalid_datetime_format | `WorkGroupHistorys` | TABLE | invalid input syntax for type date: "" |
| `42830` | class_42 | `FK_EAPPDocument_EAPPHistory` | CONSTRAINT | there is no unique constraint matching given keys for referenced table "EAPPHistory" |
| `42P01` | undefined_table | `EDMSMainList` | VIEW | relation "public.edmsdocument" does not exist |
| `42P13` | invalid_function_definition | `Contacts_GetChildGroupByGroupNo` | FUNCTION | parameter name "groupno" used more than once |
| `42804` | datatype_mismatch | `Note_SendNote` | PROCEDURE | argument of DEFAULT must be type boolean, not type integer |
| `22P02` | invalid_text_representation | `SurveyPoll` | TABLE | invalid input syntax for integer: "" |
| `42704` | class_42 | `parseJSON` | FUNCTION | type you does not exist |

## 6. Prioritized TODO (by error count)

### 1. [42601] syntax_error — 1358 failures

- **First failure**: `Note_Comments` (TABLE)
- **Example error**: syntax error at or near "["
- **Action**: Fix syntax error in converter output. Review the object SQL file manually and trace which BodyConverter phase produces the malformed SQL.

### 2. [22007] invalid_datetime_format — 16 failures

- **First failure**: `WorkGroupHistorys` (TABLE)
- **Example error**: invalid input syntax for type date: ""
- **Action**: Review objects with SqlState `22007` manually. Check converter output and compare against original MSSQL source.

### 3. [42830] class_42 — 13 failures

- **First failure**: `FK_EAPPDocument_EAPPHistory` (CONSTRAINT)
- **Example error**: there is no unique constraint matching given keys for referenced table "EAPPHistory"
- **Action**: Review objects with SqlState `42830` manually. Check converter output and compare against original MSSQL source.

### 4. [42P01] undefined_table — 8 failures

- **First failure**: `EDMSMainList` (VIEW)
- **Example error**: relation "public.edmsdocument" does not exist
- **Action**: Table not found at function-creation time. For SQL-language functions this is a hard error; for plpgsql it should be deferred. Check if the CREATE is LANGUAGE sql and convert to plpgsql, or ensure referenced tables exist first.

### 5. [42P13] invalid_function_definition — 6 failures

- **First failure**: `Contacts_GetChildGroupByGroupNo` (FUNCTION)
- **Example error**: parameter name "groupno" used more than once
- **Action**: Invalid function definition. Usually `RETURNS SETOF record` without a concrete row type. Replace with `RETURNS TABLE(col1 type1, ...)` from the original procedure's SELECT list.

### 6. [42804] datatype_mismatch — 4 failures

- **First failure**: `Note_SendNote` (PROCEDURE)
- **Example error**: argument of DEFAULT must be type boolean, not type integer
- **Action**: Type mismatch in expression or assignment. Review data type mapping in Converter.cs for the affected column/parameter type.

### 7. [22P02] invalid_text_representation — 3 failures

- **First failure**: `SurveyPoll` (TABLE)
- **Example error**: invalid input syntax for integer: ""
- **Action**: Review objects with SqlState `22P02` manually. Check converter output and compare against original MSSQL source.

### 8. [42704] class_42 — 2 failures

- **First failure**: `parseJSON` (FUNCTION)
- **Example error**: type you does not exist
- **Action**: Review objects with SqlState `42704` manually. Check converter output and compare against original MSSQL source.

## 7. Artifacts

| File | Description |
|------|-------------|
| `all-converted.sql` | All converted DDL deployed in this run |
| `runtime-validation.md` | This report |
| Database `pg_converter_runtime_test` | Live PostgreSQL database with deployed objects |

