# Production Validation Report

## Kết Luận

**FAIL**

Production SQL Server objects chưa thể được coi là convert thành công toàn bộ
trên PostgreSQL 9.3.17.

- Tổng source objects: `5,052`
- Strict PASS: `745`
- FAIL / chưa convert đầy đủ: `4,307`
- PostgreSQL files có ít nhất một runtime ERROR: `2,285`

Không sửa source hoặc converter trong quá trình validation.

## Environment

SQL Server source:

- Host: `221.148.141.4,14233`
- Database: `CrewCloud_Company_Bootstrap`
- SQL Server version: `10.50.2550.0`
- Inventory schema: toàn bộ object source nằm trong `dbo`
- Connection/read catalog: PASS

PostgreSQL target:

- Host: `221.148.141.4:5432`
- Database duy nhất được sử dụng: `pg_converter_runtime_test`
- PostgreSQL version: `9.3.17`
- `psql` version: `9.5.5`
- Không sử dụng production PostgreSQL database

Build/QA baseline:

- Build: PASS, `0` warnings, `0` errors
- Automated QA: PASS `27/27`

## Backup Và Cleanup

Target test database được backup trước khi reset:

- `reports/production-validation-artifacts-20260629_095432/target-before-production-validation.sql`

Cleanup có guard xác minh:

```text
current_database() = pg_converter_runtime_test
```

Chỉ schema `public` trong `pg_converter_runtime_test` được drop/recreate.
Không database nào khác bị xóa hoặc thay đổi.

## Source Object Totals

| Object Type | Total |
|---|---:|
| TABLE | 670 |
| VIEW | 8 |
| FUNCTION | 120 |
| PROCEDURE | 2,396 |
| INDEX | 618 |
| CONSTRAINT | 1,240 |
| **TOTAL** | **5,052** |

Constraint breakdown:

| Constraint Type | Total |
|---|---:|
| DEFAULT_CONSTRAINT | 695 |
| PRIMARY_KEY_CONSTRAINT | 527 |
| FOREIGN_KEY_CONSTRAINT | 13 |
| UNIQUE_CONSTRAINT | 5 |

## Converter Coverage

Converter database loader đọc được `3,273` objects:

- TABLE: `670`
- Routine loaded as FUNCTION: `2,516`
- INDEX: `87`

Production inventory có `120` FUNCTION và `2,396` PROCEDURE, nhưng loader trả
toàn bộ `2,516` routine dưới `ObjectType.Function`. Vì vậy PostgreSQL 9.3
procedure warning-only path không được sử dụng cho production procedures.

VIEW và CONSTRAINT được đưa qua converter nhưng chỉ sinh TODO stubs:

- VIEW STUB: `8`
- CONSTRAINT STUB: `1,240`

INDEX loader chỉ đưa vào `87/618`; còn `531` index không được load.

## PASS / FAIL Theo Object Type

Strict PASS yêu cầu:

- Object được converter xử lý, không phải TODO/STUB.
- File không có PostgreSQL ERROR.
- Object cần tạo phải thực sự tồn tại trong target catalog.
- Procedure bị tạo nhầm thành function không được tính PASS.

| Object Type | Total | PASS | FAIL |
|---|---:|---:|---:|
| TABLE | 670 | 662 | 8 |
| VIEW | 8 | 0 | 8 |
| FUNCTION | 120 | 11 | 109 |
| PROCEDURE | 2,396 | 0 | 2,396 |
| INDEX | 618 | 72 | 546 |
| CONSTRAINT | 1,240 | 0 | 1,240 |
| **TOTAL** | **5,052** | **745** | **4,307** |

INDEX failure breakdown:

| Status | Count |
|---|---:|
| PostgreSQL runtime error | 7 |
| Converter could not parse | 3 |
| `psql` success nhưng expected index không tồn tại | 5 |
| Không được loader load | 531 |
| **Total INDEX FAIL** | **546** |

## PostgreSQL Target Catalog Sau Khi Chạy

| Catalog Object | Actual |
|---|---:|
| TABLE | 662 |
| VIEW | 0 |
| FUNCTION | 949 |
| INDEX, gồm PK indexes | 220 |
| PRIMARY KEY | 148 |
| FOREIGN KEY | 0 |

`949` PostgreSQL functions không đồng nghĩa 949 source FUNCTION pass. Nhiều
source PROCEDURE đã bị loader phân loại sai và tạo dưới dạng function hoặc để
lại partial output. Chỉ `11/120` source FUNCTION có error-free file và đúng
source type.

`148` PRIMARY KEY được tạo gián tiếp từ TABLE metadata, nhưng dedicated
CONSTRAINT conversion vẫn là STUB. Không có source FOREIGN KEY nào được tạo.

## Runtime Execution

Generated PostgreSQL output:

- `reports/production-validation-artifacts-20260629_095432/all-converted.sql`
- Per-object SQL directory:
  `reports/production-validation-artifacts-20260629_095432/objects/`

Execution driver:

- `reports/production-validation-artifacts-20260629_095432/execute-all.sql`
- Includes: `4,521` converter artifacts
- Elapsed time: khoảng `748.91` giây
- `ON_ERROR_STOP` được tắt để tiếp tục test tất cả object

`psql` process exit code là `0` vì batch được cấu hình tiếp tục qua lỗi. Đây
không phải kết quả PASS. Log chứa:

- PostgreSQL ERROR lines: `2,294`
- Unique files có ERROR: `2,285`
- NOTICE lines: `2,507`

Logs:

- `reports/production-validation-artifacts-20260629_095432/execution.stdout.log`
- `reports/production-validation-artifacts-20260629_095432/execution.stderr.log`

## Các Object Lỗi

Danh sách đầy đủ:

- Tất cả object và trạng thái:
  `reports/production-validation-artifacts-20260629_095432/production-object-results.csv`
- Chỉ object FAIL:
  `reports/production-validation-artifacts-20260629_095432/failed-objects.csv`
- Chỉ object PASS:
  `reports/production-validation-artifacts-20260629_095432/passed-objects.csv`
- PostgreSQL runtime errors:
  `reports/production-validation-artifacts-20260629_095432/postgresql-runtime-errors.csv`

TABLE runtime failures:

| Object | PostgreSQL Error |
|---|---|
| `EAPPErpState` | Syntax error near reserved word `desc` |
| `Mail_Mails` | Syntax error near reserved word `To` |
| `Main_InitialWidgetPlacements` | Syntax error near reserved word `Left` |
| `Main_UserWidgetPlacements` | Syntax error near reserved word `Left` |
| `Main_WidgetPlacements` | Syntax error near reserved word `Left` |
| `sysdiagrams` | Type `sysname` does not exist |
| `WorkingTime_RequestCorrectionTime` | Type `datetimeoffset` does not exist |
| `WorkingTime_Times_v2` | Type `datetimeoffset` does not exist |

Representative FUNCTION failures:

| Object | PostgreSQL Error |
|---|---|
| `AddWorkingDayTimes` | Syntax error near `(` |
| `Board_GetBoardAllow` | Syntax error near `RETURN` |
| `ChangeTimeOffset` | Missing `THEN` |
| `COMNGetDepartName` | Syntax error near `SELECT` |
| `Contacts_GetChildGroupByGroupNo` | Parameter name used more than once |
| `Contacts_StringToListInt` | Syntax error near `(` |

Representative silent/non-runtime failures:

- Three INDEX files contain only `-- Could not parse index`.
- Five INDEX files returned success but expected `(table,index)` was absent,
  caused by duplicate index-name guard behavior.
- 531 INDEX objects were not loaded.
- 8 VIEW objects are TODO stubs.
- 1,240 CONSTRAINT objects are TODO stubs.
- 2,396 PROCEDURE objects are misclassified as FUNCTION.

## Nguyên Nhân Chính

1. **PROCEDURE bị phân loại sai thành FUNCTION**  
   Inventory có 2,396 procedures nhưng loader không trả object nào có type
   Procedure. Khả năng cao `sys.objects.type` là `char(2)` có padding (`"P "`)
   trong khi code so sánh trực tiếp với `"P"`.

2. **VIEW và CONSTRAINT chưa được implement**  
   Converter hiện trả TODO stubs. Raw constraint definitions đôi khi còn được
   phát như SQL độc lập và tạo thêm PostgreSQL syntax errors.

3. **INDEX coverage thiếu**  
   Loader chỉ load 87/618 indexes; PK/unique constraints và các category khác
   không đi qua index converter.

4. **Identifier không được quote an toàn**  
   Column names như `desc`, `To`, `Left` xung đột PostgreSQL keywords.

5. **Datatype chưa hỗ trợ**  
   Ví dụ `sysname`, `datetimeoffset`; một số routine còn sinh `serial` hoặc
   `bigserial` ở context không hợp lệ.

6. **T-SQL body chưa chuyển hoàn chỉnh sang PL/pgSQL**  
   Các lỗi phổ biến gồm duplicate parameters, thiếu `THEN`, T-SQL `SET`,
   `RETURN`, temp-table marker `#`, và DML/control-flow syntax còn sót.

7. **Index name collision bị skip im lặng**  
   Guard kiểm tra `indexname` toàn schema có thể coi index trùng tên ở table
   khác là đã tồn tại.

## Top 20 Lỗi PostgreSQL Phổ Biến

Các count dưới đây dùng lỗi đầu tiên của mỗi object/file.

| Rank | Count | Error Category | Example Object |
|---:|---:|---|---|
| 1 | 343 | Duplicate parameter name | `Approval_GetAttachment` |
| 2 | 224 | Syntax error near `0` | `DDay_InsertSharers` |
| 3 | 217 | Missing `THEN` at end of SQL expression | `Approval_GetApproximateDocuments` |
| 4 | 158 | Syntax error near empty string literal | `DF_AccessLog_ClientIP` |
| 5 | 157 | Syntax error near `getdate` | `DF_Board_AllowAccess_ModDate` |
| 6 | 121 | Syntax error near `RETURN` | `Approval_GetDocument` |
| 7 | 113 | Syntax error near `table` | `Approval_GetDocuments` |
| 8 | 109 | Syntax error near `SET` | `Approval_InsertAttachment` |
| 9 | 103 | Type `serial` does not exist in this context | `Board_GetAllowByItem` |
| 10 | 69 | Syntax error near `IF` | `Board_UpdateConfig` |
| 11 | 57 | Syntax error near `(` | `AddWorkingDayTimes` |
| 12 | 52 | Syntax error near `1` | `Drive_InsertPemissionCommonFolders` |
| 13 | 48 | Syntax error near `END` | `Authority_GetModulePermission` |
| 14 | 40 | Syntax error near `;` | `Board_InsertNotificationService` |
| 15 | 34 | Syntax error near `#` | `Board_DeleteDepartAllowAccess` |
| 16 | 32 | Syntax error near `SELECT` | `BSLG_ReaderMod` |
| 17 | 26 | Syntax error near `INSERT` | `Board_InsertAndroidDevice` |
| 18 | 26 | Syntax error near `,` | `Board_GetAllBoardContents` |
| 19 | 24 | Syntax error near `N` | `DF__Commute_S__Conte__1D8D732C` |
| 20 | 20 | Syntax error near `UPDATE` | `Approval_UpdateDocument` |

Machine-readable top 20:

- `reports/production-validation-artifacts-20260629_095432/top-20-postgresql-errors.csv`

## Artifacts

- Source inventory:
  `reports/production-validation-artifacts-20260629_095432/source-inventory.csv`
- Source summary:
  `reports/production-validation-artifacts-20260629_095432/source-summary.txt`
- Constraint type breakdown:
  `reports/production-validation-artifacts-20260629_095432/source-constraint-types.csv`
- Conversion manifest:
  `reports/production-validation-artifacts-20260629_095432/conversion-manifest.csv`
- Full PostgreSQL output:
  `reports/production-validation-artifacts-20260629_095432/all-converted.sql`
- Detailed PASS/FAIL:
  `reports/production-validation-artifacts-20260629_095432/production-object-results.csv`

## Final Status

**Production Validation: FAIL**

Sample QA `27/27` và sample runtime trước đó vẫn PASS, nhưng production-scale
validation cho thấy coverage và runtime correctness chưa đủ cho database thật.
Không có lỗi nào được tự sửa trong bước này.
