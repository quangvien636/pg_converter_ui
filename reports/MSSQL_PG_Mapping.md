# MSSQL to PostgreSQL Feature Mapping Compatibility Matrix

This matrix documents the unsupported or partially supported MSSQL features in the current converter, their PostgreSQL equivalents, the exact C# function to modify to add support, and the implementation priority.

---

## Compatibility Matrix

| Feature | MSSQL Syntax | PostgreSQL Equivalent | Converter Function to Modify | Priority |
|---------|--------------|-----------------------|------------------------------|----------|
| **T-SQL Cursors** | `DECLARE cur CURSOR FOR SELECT col FROM tab`<br>`OPEN cur`<br>`FETCH NEXT FROM cur INTO var`<br>`CLOSE cur; DEALLOCATE cur;` | `FOR rec IN SELECT col FROM tab LOOP`<br>&nbsp;&nbsp;&nbsp;&nbsp;`var := rec.col;`<br>`END LOOP;` | `pg_converter_ui.BodyConverter.Convert` | **High** |
| **Transaction Control** | `BEGIN TRAN`<br>`COMMIT TRAN`<br>`ROLLBACK TRAN` | None (PL/pgSQL functions run within an implicit transaction; control statements should be stripped). | `pg_converter_ui.BodyConverter.Convert` | **High** |
| **Identity Column on Temp Tables** | `CREATE TABLE #temp (`<br>&nbsp;&nbsp;&nbsp;&nbsp;`id INT IDENTITY(1,1)`<br>`)` | `CREATE TEMP TABLE temp (`<br>&nbsp;&nbsp;&nbsp;&nbsp;`id serial`<br>`)` | `pg_converter_ui.BodyConverter.Convert` | **High** |
| **GETDATE in Parameter Defaults** | `CREATE PROCEDURE p`<br>&nbsp;&nbsp;&nbsp;&nbsp;`@d DATE = GETDATE`<br>`AS ...` | `CREATE FUNCTION p(`<br>&nbsp;&nbsp;&nbsp;&nbsp;`d date DEFAULT CURRENT_DATE`<br>`) ...` | `pg_converter_ui.Converter.MapDefault` | **High** |
| **XML Parsing via OPENXML** | `EXEC sp_xml_preparedocument @doc OUTPUT, @xml`<br>`SELECT * FROM OPENXML(@doc, '/path') WITH (...)` | `SELECT * FROM xmltable('/path' PASSING xml_var COLUMNS ...)` | `pg_converter_ui.BodyConverter.Convert` | **Medium** |
| **Redundant Union Order By** | `SELECT col FROM a ORDER BY col`<br>`UNION ALL`<br>`SELECT col FROM b ORDER BY col` | `SELECT col FROM a`<br>`UNION ALL`<br>`SELECT col FROM b` | `pg_converter_ui.BodyConverter.Convert` | **Medium** |
| **CHARINDEX String Search** | `CHARINDEX(substring, string)` | `STRPOS(string, substring)` | `pg_converter_ui.BodyConverter.Convert` | **Medium** |
| **DATEADD Interval Arithmetic** | `DATEADD(dd, days, date_val)` | `date_val + interval '1 day' * days`<br>(or `date_val + days`) | `pg_converter_ui.BodyConverter.Convert` | **High** |
| **Double Quoted String Literals** | `"string_val"` | `'string_val'` | `pg_converter_ui.BodyConverter.Convert` | **Medium** |
