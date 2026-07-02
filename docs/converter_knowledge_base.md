# Converter knowledge base

Nguồn chính: Claude command/skill document `pgsql-fix` (đọc ngày 2026-07-02).
Các rule dưới đây đã được đối chiếu với converter và báo cáo runtime của
`pg_converter_ui`; chúng không phải danh sách thay thế máy móc.

| Rule | MSSQL pattern | PostgreSQL replacement | Project examples | Risk | Runtime validation | Regression suggestion | Applicability |
|---|---|---|---|---|---|---|---|
| Runtime after compile | Procedure tạo được nhưng embedded SQL chưa chạy | Gọi routine với input có kiểu trong transaction rollback | Toàn bộ Board/Contact | Low | Bắt SQLSTATE, context, SQL và thời gian; compile không phải runtime PASS | Runner must reject databases other than `pg_converter_runtime_test` | Already implemented |
| SETOF fixed shape | Result set có danh sách cột cố định | `RETURNS TABLE(...)`, hoặc call `AS t(col type, ...)` khi shape được chứng minh | 183 blocked tại baseline `32d24b6` | Medium | Infer mọi `RETURN QUERY` bằng metadata-only query; các nhánh phải cùng shape | Same-shape and conflicting-branch fixtures | Useful for current runtime failures |
| SETOF unknown shape | Nhiều result set/biến cục bộ làm shape không suy luận được | Giữ `SETOF record`; yêu cầu metadata nguồn/manual review | 93 blocked sau inference | High | Không tạo column list giả; giữ BLOCKED với nguyên nhân | Ensure unsafe inference remains blocked | Risky / needs manual review |
| Ambiguous parameter/column | `@UserNo` trùng `UserNo` và column dùng bare | Copy param sang `l_userno`; alias table và qualify mọi column trùng tên | 160 lỗi `42702`; `board_getallboardcontents`, `contacts_updatecontactimportant` | High | Rerun đúng procedure và input đã lỗi | LHS/RHS parameter plus unaliased table cases | Useful for current runtime failures |
| LEN | `LEN(value)` | `LENGTH(value)` | `contacts_deletehistory`, `contacts_setaddress`, `contacts_setemail`, `contacts_setnumber`, `contacts_savearrange*`, `contacts_saverestore` | Low | Phải hết `42883 len(...)` và procedure thực thi | Nested `SUBSTRING(..., LEN(x))` | Already implemented / current expansion |
| CHARINDEX | `CHARINDEX(needle, haystack)` | `STRPOS(haystack, needle)`; đảo thứ tự argument | Contact list parsing | Medium | Kiểm tra delimiter literal và runtime result | Comma literal and expression arguments | Already implemented |
| PATINDEX | `PATINDEX(pattern, value)` | Không có mapping tổng quát; dùng regex/position theo pattern cụ thể | Chưa có lỗi hiện tại được ghi nhận | High | Chỉ sửa khi có SQLSTATE và input cụ thể | Pattern classes and no-match semantics | Useful later |
| ParseJson | `ParseJson(json)` + filter theo key | `json::json ->> key` cho pattern key/value đã xác nhận | `board_getallboardcontents` | Medium | So sánh NULL, malformed JSON và missing key | Known key extraction plus invalid JSON | Useful for current runtime failures when observed |
| Split helpers | `SplitString`, `fn_split_array`, `fnStringToListInt` | `string_to_array`; cast element/array theo source contract | `board_deletecurrentmanager`, Contact change-group routines | Medium | Helper bootstrap chỉ khi signature/row shape được chứng minh | Empty string, duplicate delimiter, invalid integer | Useful for current runtime failures |
| Cursor loop | DECLARE/FETCH/WHILE cursor lifecycle | `FOR rec IN SELECT ... LOOP` | Board cursor conversions | High | Kiểm tra ordering, row count và side effects | Multi-fetch, empty cursor, early exit | Already implemented; manual runtime review |
| Temp table | `#Temp`, `SELECT INTO #Temp` | PostgreSQL temp table `ON COMMIT DROP`, CTE, variables, hoặc direct loop | Contact arrange/restore flows | High | Kiểm tra isolation và cleanup dưới rollback | Repeated invocation in one session | Risky / needs manual review |
| Dynamic SQL | `EXEC`, `sp_executesql`, concatenated SQL | `EXECUTE`, preferably `format()` with bound `USING` values | Android notification options, Contact dynamic queries | High | Capture internal query/context; test quotes and NULL | Quotes, commas, named bindings, injection boundary | Useful for current runtime failures |
| FOR XML aggregation | `STUFF(... FOR XML PATH(''))` | PG 9.3-compatible array aggregation/string assembly | `Board_GetTreeSubMenu_V2_Json` | High | Compare ordering, escaping and empty-set behaviour | Unicode literals and ordered aggregation | Already implemented |
| Identity | `SCOPE_IDENTITY()` | `INSERT ... RETURNING id INTO var`; avoid `MAX(id)`/manual `setval` | Board insert routines | Medium | Verify returned ID and sequence rollback semantics | Concurrent-safe pattern | Useful later |
| Recursive CTE | Recursive MSSQL CTE | `WITH RECURSIVE`; DML may require `USING` | Folder/tree procedures | High | Compare depth, cycle behaviour and ordering | Empty tree, deep tree, cycle fixture | Useful later |
| Boolean comparison | BIT column `= 1/0` | `= TRUE/FALSE` only after confirming actual type | Board permissions/content flags | Medium | Do not convert integer flags such as `SpecType` | Boolean column versus integer flag | Already implemented; manual review |
| Identifier case | Quoted source-case table, unquoted routine reference | Use one consistent lowercase identifier strategy | `"Board_Boards"` versus `board_boards` dependency bootstrap | Medium | Verify catalog identity and outward column casing separately | Quoted/unquoted table and result-column cases | Useful for current runtime dependencies |
| Regex limitation | Nested SQL/comments/strings parsed by global regex | Token/stack/AST only for a proven failing construct | Dynamic SQL, deep IF/ELSE, result-shape extraction | High | Require measurable runtime benefit | Minimal failing source plus sibling regression suite | Risky / needs manual review |
| Encoding | BOM, smart quotes, mojibake | UTF-8 without BOM; normalize only text encoding | Vietnamese UI/docs | Low for docs, high for SQL literals | Do not alter SQL logic/literals while cleaning | Byte/round-trip test | Useful later |

## Project-specific guardrails

- PostgreSQL execution is permitted only on `pg_converter_runtime_test`.
- Every dependency and routine invocation lives under an outer `BEGIN` and final
  `ROLLBACK`; per-routine savepoints isolate failures.
- A runtime PASS means execution only. Behavioural equivalence requires SQL Server
  output/side-effect comparison.
- A rule is implemented only after an observed failure identifies its target.
- PostgreSQL 9.3 compatibility remains the conversion target.
