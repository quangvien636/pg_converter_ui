# PROJECT_CONTEXT

Ghi chú vận hành: từ các lần sau, trước khi sửa code trong project này, hãy đọc file này trước để nắm kiến trúc và các rủi ro hiện tại.

## Mục tiêu dự án

`pg_converter_ui` là ứng dụng desktop Windows Forms dùng để hỗ trợ chuyển đổi schema/module từ Microsoft SQL Server sang PostgreSQL.

Luồng chính:

1. Người dùng nhập thông tin kết nối MSSQL.
2. App đọc objects trong schema `dbo` từ catalog SQL Server (`sys.objects`, `sys.tables`, `sys.columns`, `sys.indexes`).
3. App hiển thị danh sách function/stored procedure, table, index để lọc/chọn.
4. App generate script PostgreSQL tương ứng, highlight các lỗi/TODO/warning, cho phép copy hoặc save `.sql`.

Đây là công cụ hỗ trợ chuyển đổi bán tự động. Output PostgreSQL, đặc biệt với stored procedure/function phức tạp, vẫn cần review thủ công.

## Cấu trúc thư mục

```text
E:\pg_converter_ui\
  pg_converter_ui.csproj       # Project .NET WinForms
  pg_converter_ui.csproj.user  # Metadata Visual Studio: Form1.cs là Form
  Program.cs                   # Entry point, global exception handlers, app lifecycle logging
  Form1.cs                     # UI chính và event handlers, dựng UI bằng code
  Form1.Designer.cs            # Designer shell tối thiểu
  Models.cs                    # DbObject, ColumnInfo, ObjectType
  MssqlDbReader.cs             # Kết nối MSSQL và đọc catalog objects
  MssqlParser.cs               # Parser file SQL theo GO blocks, search/filter helper
  Converter.cs                 # Chuyển DbObject sang PostgreSQL SQL
  BodyConverter.cs             # Chuyển đổi body MSSQL phức tạp sang PL/pgSQL dạng best-effort
  Logger.cs                    # File logger theo ngày
  bin/                         # Build output, generated
  obj/                         # MSBuild intermediate output, generated
  publish/                     # Published executable/output hiện có
```

Không thấy `.git` trong thư mục hiện tại khi scan.

## Dependency và nền tảng

- .NET SDK/project target: `net10.0-windows`
- App type: `WinExe`
- UI: Windows Forms (`UseWindowsForms=true`)
- Nullable + implicit usings bật trong `.csproj`
- NuGet dependency trực tiếp:
  - `Microsoft.Data.SqlClient` version `7.0.2`

Không có backend HTTP/API, frontend web, database local, migration framework, hoặc test project riêng. "Frontend" ở đây là WinForms desktop UI; "database" là MSSQL nguồn bên ngoài và PostgreSQL output dạng script.

## Cách chạy project

Yêu cầu: Windows + .NET SDK/Runtime có Windows Desktop support cho target `net10.0-windows`.

Chạy từ root:

```powershell
dotnet run
```

Hoặc chạy binary đã build/publish:

```powershell
.\bin\Debug\net10.0-windows\pg_converter_ui.exe
.\publish\pg_converter_ui.exe
```

Lưu ý: `publish\pg_converter_ui.exe` hiện là file lớn khoảng 122 MB, có vẻ là self-contained/single-file publish.

## Cách build/test

Build debug:

```powershell
dotnet build
```

Kết quả scan ngày 2026-06-26: `dotnet build` thành công, `0 Warning(s)`, `0 Error(s)`.

Publish gợi ý theo output hiện tại:

```powershell
dotnet publish -c Release -r win-x64 -p:PublishSingleFile=true --self-contained true -o publish
```

Hiện chưa có test project/unit tests. Vì vậy "test" thực tế đang là:

```powershell
dotnet build
```

và test thủ công bằng UI/kết nối MSSQL/generate script.

## Các module chính

### Program.cs

- Cấu hình unhandled exception handling cho UI thread và AppDomain.
- Ghi log start/exit bằng `Logger`.
- Khởi tạo WinForms và chạy `new Form1()`.

### Form1.cs

- Dựng toàn bộ UI bằng code trong `BuildUI()`.
- Các vùng UI:
  - Connection panel: server, database, Windows/SQL auth, user/pass, connect/load.
  - Filter/search panel: module, owner, search, checkbox function/table/index.
  - Results `ListView`: danh sách objects, trạng thái `OK`/`STUB`.
  - Output `RichTextBox`: script PostgreSQL, syntax/status highlighting đơn giản.
- Event chính:
  - `ConnectAndLoad`: gọi `MssqlDbReader.Load` bằng `Task.Run`.
  - `DoSearch`: lọc `_allObjects` qua `MssqlParser.Search`.
  - `GenerateScript`: gọi `Converter.Convert` cho từng object đã chọn.
  - `SaveOutput`, `OpenLog`, `HighlightOutput`.

### MssqlDbReader.cs

- Tạo connection string cho Windows Auth hoặc SQL Auth.
- Đọc object thật từ SQL Server schema `dbo`:
  - Functions/procedures: `sys.sql_modules` + `sys.objects`, type `P`, `FN`, `TF`, `IF`.
  - Tables: `sys.tables`, `sys.columns`, `sys.types`, primary key metadata.
  - Indexes: `sys.indexes`, `sys.index_columns`, `sys.columns`.
- Table metadata được serialize vào `DbObject.RawBlock` dạng custom text:
  - Header `__TABLE_FROM_CATALOG__`
  - Mỗi cột là dòng `COL|...`
- `ParseTableRaw` đọc lại format này cho converter.

### MssqlParser.cs

- Parser cho file SQL text, split theo dòng `GO`.
- Nhận diện `CREATE/ALTER PROCEDURE|PROC|FUNCTION`, `CREATE TABLE`, `CREATE INDEX` bằng regex.
- Search hỗ trợ wildcard `*` và `?`.
- Hiện chưa được nối vào UI load file; UI hiện load DB trực tiếp.

### Converter.cs

- Dispatch theo `ObjectType`.
- Function/procedure:
  - Parse header/params bằng regex.
  - Map params MSSQL sang PostgreSQL.
  - Convert body qua `BodyConverter` nếu object được đánh dấu phức tạp.
  - Tự suy luận `RETURNS void`, `RETURNS TABLE(...)`, hoặc fallback `SETOF record`.
  - Inject `RETURN QUERY` cho SELECT trả kết quả.
  - Qualify param names để giảm lỗi ambiguous column.
- Table:
  - Nếu load từ catalog thì dùng `ColumnInfo`.
  - Nếu parse từ raw SQL thì dùng regex và replace type/clauses.
- Index:
  - Convert sang `CREATE INDEX` trong `DO $$ BEGIN IF NOT EXISTS ... END $$;` để tương thích PostgreSQL cũ không có `CREATE INDEX IF NOT EXISTS`.
- Type mapping chính: `int -> integer`, `bit -> boolean`, `datetime -> timestamp without time zone`, `nvarchar/varchar -> character varying/text`, `uniqueidentifier -> uuid`, `varbinary/image -> bytea`, v.v.

### BodyConverter.cs

- Best-effort transformations cho stored procedure/function body:
  - Strip MSSQL boilerplate như `SET NOCOUNT ON`.
  - Cursor sang `FOR _rec IN ... LOOP`.
  - Temp table `#name` sang temp table PostgreSQL.
  - `EXEC`/`sp_executesql` sang `PERFORM`/`EXECUTE`.
  - Một số `MERGE` sang `UPDATE + INSERT`, fallback TODO.
  - `OPENQUERY` sang template `dblink`, `OPENROWSET` sang TODO.
  - `RAISERROR`/`THROW` sang `RAISE`.
  - `IF/ELSE/WHILE/BEGIN/END` sang PL/pgSQL control flow.
  - Assignment `SET @var =`, `SELECT @var =` sang `:=`/`SELECT INTO`.
- `IsTrueStub` hiện chỉ đánh dấu CLR (`EXTERNAL NAME`) là unhandleable/STUB.

### Logger.cs

- Ghi log vào `logs\converter_yyyyMMdd.log` bên cạnh executable (`AppDomain.CurrentDomain.BaseDirectory`).
- Logger nuốt exception để không làm crash app.

## Quy ước code hiện tại

- Namespace duy nhất: `pg_converter_ui`.
- Code C# file-scoped namespace.
- Static helper classes cho parser/converter/reader/logger.
- UI code procedural trong `Form1.BuildUI`, dùng field controls thay vì designer layout đầy đủ.
- Conversion dựa chủ yếu trên regex, không có SQL AST/parser.
- Output script dùng schema `public` hard-code.
- SQL Server input query hard-code schema `dbo`.
- Log dùng text file theo ngày.
- Save output dùng UTF-8 không BOM: `new UTF8Encoding(false)`.

## Các lỗi/rủi ro hiện tại

1. Credentials từng được hard-code trong UI đã được thay bằng các biến môi
   trường `PG_CONVERTER_MSSQL_SERVER`, `PG_CONVERTER_MSSQL_USER` và
   `PG_CONVERTER_MSSQL_PASSWORD`. Không đưa giá trị thật vào source hoặc báo cáo.

2. Text tiếng Việt/emoji trong source đang bị mojibake ở nhiều nơi (`Lá»—i`, `Káº¿t ná»‘i`, ký tự icon bị hỏng). Build vẫn qua, nhưng UI/log/message sẽ hiển thị sai nếu nội dung đã bị lưu sai encoding.

3. Không có `.gitignore` trong root hiện tại và `bin/`, `obj/`, `publish/`, log đang nằm trong project folder. Nếu đưa vào git, cần ignore generated outputs và logs.

4. Không có test tự động. Các thay đổi converter dễ gây regression vì phần lớn logic là regex transformation.

5. Converter không phải SQL parser đầy đủ. Các stored procedure phức tạp, dynamic SQL, nested query, MERGE/OPENQUERY/cursor edge cases có thể generate SQL sai hoặc cần TODO review.

6. Schema assumptions hard-code:
   - Input chỉ đọc `dbo`.
   - Output luôn `public`.
   - Owner lấy từ UI, default `"dazone"`.

7. `MssqlDbReader.BuildTableRaw` dùng format custom delimiter `COL|...`; nếu tên/type chứa `|` hoặc newline bất thường sẽ parse sai. Với metadata SQL Server thường ít gặp nhưng vẫn là coupling mỏng.

8. Connection string tự ghép chuỗi trực tiếp từ UI input. Nên cân nhắc `SqlConnectionStringBuilder` để tránh lỗi khi password/user/server chứa ký tự đặc biệt.

9. `MssqlParser.ParseFile` tồn tại nhưng UI hiện không có flow import SQL file. Có thể là feature dang dở hoặc code cũ.

10. `ObjectType.Function` đang đại diện cả function và stored procedure, tên hơi lệch domain.

11. App target `net10.0-windows`, cần môi trường .NET 10/Windows Desktop tương ứng. Nếu máy khác chưa có runtime phù hợp thì nên dùng publish self-contained.

12. `QualifyParams` (Converter.cs, ~dòng 1717) chỉ qualify tham số khi nó
    đứng NGAY SAU một operator so sánh (`=`, `<>`, `<=`, ...), tức chỉ xử
    lý tham số ở vế phải. Tham số đứng ở vế trái của phép so sánh
    (`@IsAlarm=0` trong MSSQL, rất phổ biến) không được qualify, và khi
    tên tham số trùng (không phân biệt hoa/thường) với một cột thật của
    bảng trong cùng câu SQL (`Board_Contents.IsAlarm`, `Board_AllowAccess.UserNo`),
    PostgreSQL báo `42702 column reference "x" is ambiguous`. Việc qualify
    vế phải không giúp gì vì tham số vẫn còn "visible" dưới tên gốc trong
    scope PL/pgSQL bất kể qualify bao nhiêu chỗ khác.
    Đã tái hiện trực tiếp bằng cách feed nguyên văn MSSQL source của
    `Board_GetAllBoardContents` (từ bản export MSSQL cục bộ)
    qua `Converter.Convert` — xem harness tại
    `qa\BoardGetAllBoardContentsConvert\Program.cs`. Output vẫn còn
    `WHERE ItemType=2 AND UserNo=board_getallboardcontents.userno` (cột
    `UserNo` bên trái không được qualify) và `IsAlarm = FALSE ... AND
    IsAlarm = TRUE` (tham số `isalarm` ở vế trái, không qualify).
    Đây chính là lỗi runtime `42702 ambiguous "userno"` / `42702 ambiguous
    "isalarm"` đã phải sửa tay trực tiếp trên DB production ngày
    2026-07-01 cho hàm `board_getallboardcontents`.
    Hướng sửa khả thi: thay vì chỉ qualify vế phải, generate một local
    variable `l_<param>` cho MỌI tham số ở đầu function (`DECLARE l_x
    type; BEGIN l_x := x;`) và thay toàn bộ occurrence của tham số (cả
    hai vế) bằng `l_<param>` — cách này đã dùng thủ công cho
    `board_downboardbyuser`/`board_upboardbyuser` và cho bản fix mới của
    `board_getallboardcontents`.

13. Converter không có mapping cho hàm scalar tuỳ biến phía MSSQL không
    tồn tại sẵn trong PostgreSQL, ví dụ `ParseJson(col)` (custom
    function trong DB nguồn, dùng để tách 1 field JSON theo key qua
    bảng kết quả `(StringValue, Name)`). Converter giữ nguyên lời gọi
    `ParseJson(...)` trong output PG → `42883 function parsejson(...)
    does not exist` khi chạy thật. Cùng logic thực tế thường nên dịch
    sang toán tử JSON gốc của PG: `col::json->>key`. Xem cùng harness ở
    mục 12; output vẫn chứa `ParseJson(B.Name)` y nguyên không có TODO
    cảnh báo nào được sinh ra cho dòng này (không có warning nào cho
    unresolved function call kiểu này), nên rủi ro bị bỏ sót cao nếu chỉ
    nhìn qua danh sách TODO ở đầu file.
