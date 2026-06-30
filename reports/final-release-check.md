# Final Release Check

## 1. Build Result

- Status: **PASS**
- Command: `dotnet build`
- Warnings: `0`
- Errors: `0`

## 2. QA Result

- Status: **PASS**
- Automated checks: `27/27`
- PASS: `27`
- FAIL: `0`
- Command:
  `dotnet run --project $env:TEMP\PgConverterQaRunner2\PgConverterQaRunner.csproj`

## 3. Runtime Validation Result

- Status: **PASS theo bộ test hiện tại**
- Generated SQL files: `12/12 PASS`
- Runtime file failures: `0`
- Tables created: `2`
- Functions created: `2`
- Indexes present: `8`, gồm các PRIMARY KEY indexes
- Foreign keys created: `1`
- Stored procedures created: `0`, chủ động dùng warning-only cho PostgreSQL 9.3

## 4. PostgreSQL Version Test

- Test server: `221.148.141.4:5432`
- Test database: `pg_converter_runtime_test`
- PostgreSQL server: `9.3.17`
- Client: `psql 9.5.5`
- Connection: **PASS**

## 5. Smoke Test Result

- Insert `Users`, kiểm tra identity và boolean default: **PASS**
- Insert `Orders`, kiểm tra foreign key: **PASS**
- Call `fn_userlabel('QA', TRUE)`: **PASS**, trả về `QA Active`
- Call `fn_userorders(1)`: **PASS**, trả về order `(1, 25.50)`
- Tổng: **4/4 PASS**

## 6. Các Lỗi Runtime Đã Sửa

- ID-001: `IDENTITY` dùng `SERIAL/BIGSERIAL` cho PostgreSQL 9.3.
- ID-013: bỏ precision không hợp lệ khỏi `timestamp without time zone`.
- ID-014/015: giữ danh sách cột PRIMARY KEY.
- ID-016: bỏ `ASC/DESC` khỏi table-level PRIMARY KEY.
- ID-018: map boolean default `0/1` thành `false/true`.
- ID-019: không sinh `gen_random_uuid()` khi extension chưa xác minh.
- ID-020: bỏ TABLE OWNER command với role chưa xác minh.
- ID-005/006: bỏ FUNCTION OWNER command với role chưa xác minh.
- ID-003/004: không sinh PROCEDURE DDL không được PostgreSQL 9.3 hỗ trợ.
- ID-017: map schema `dbo` sang `public`.
- ID-021: sửa scalar function parameters và string concatenation.
- ID-022: sửa TVF return types và `RETURN QUERY`.
- Các lỗi INDEX phụ thuộc table được giải quyết theo cascade sau khi table tạo thành công.

## 7. Warning Và Manual Rewrite Còn Lại

- `NEWID()` không có default tự động; cần manual rewrite hoặc xác minh extension `uuid-ossp`.
- OWNER mapping bị bỏ qua khi target role chưa được xác minh.
- Stored procedure chỉ sinh warning, không tạo function thay thế tự động.
- Procedure return code cần manual rewrite.
- Dynamic SQL cần manual rewrite.
- Result-returning SELECT trong procedure cần review thủ công.
- `TOP` trong procedure cần rewrite sang `LIMIT` phù hợp.
- SQL Server CLUSTERED index cần review vì PostgreSQL không duy trì clustering tương đương.
- Filtered index sample chạy được nhưng điều kiện filter chưa được chứng minh giữ nguyên semantics.
- `INCLUDE` columns sample đang bị giản lược; cần review hiệu năng và covering-index semantics.

## 8. Giới Hạn

- Chỉ PASS theo bộ test hiện tại.
- Chưa đảm bảo mọi T-SQL phức tạp.
- Stored procedure trên PostgreSQL 9.3 đang warning manual rewrite.
- Runtime PASS không đồng nghĩa mọi object SQL Server đều tương đương về behavior hoặc performance.
- Dynamic SQL, temp/table variables, TRY/CATCH, MERGE và các tổ hợp nested phức tạp vẫn cần test bằng SQL thật.

## 9. Kết Luận

**Converter đã đạt trạng thái có thể test tiếp với bộ SQL thật.**

Runtime PASS theo bộ test hiện tại trên PostgreSQL 9.3.17, nhưng không kết luận
converter đúng 100% cho mọi trường hợp MSSQL.
