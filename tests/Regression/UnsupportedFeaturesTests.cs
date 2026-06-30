using NUnit.Framework;
using pg_converter_ui;

namespace RegressionTests
{
    [TestFixture]
    public class UnsupportedFeaturesTests
    {
        // ─── 1. TOP clause mapping ───────────────────────────────────────────
        [Test]
        public void TestTOP()
        {
            string mssql = "CREATE PROCEDURE dbo.TestTop AS BEGIN SELECT TOP 10 Col FROM Tab END";
            var obj = new DbObject("testtop", ObjectType.Procedure, mssql, false, "OK");
            string pg = Converter.Convert(obj, "postgres");

            Assert.That(pg, Does.Contain("LIMIT 10"));
            Assert.That(pg, Does.Not.Contain("TOP 10"));
        }

        // ─── 2. OUTPUT clause mapping ────────────────────────────────────────
        [Test]
        public void TestOUTPUT()
        {
            string mssql = "CREATE PROCEDURE dbo.TestOutput AS BEGIN INSERT INTO Tab (Col) OUTPUT inserted.Id VALUES (1) END";
            var obj = new DbObject("testoutput", ObjectType.Procedure, mssql, false, "OK");
            string pg = Converter.Convert(obj, "postgres");

            Assert.That(pg, Does.Contain("RETURNING Id"));
            Assert.That(pg, Does.Not.Contain("OUTPUT"));
        }

        // ─── 3. MERGE statement mapping ──────────────────────────────────────
        [Test]
        public void TestMERGE()
        {
            string mssql = "CREATE PROCEDURE dbo.TestMerge AS BEGIN MERGE INTO Target T USING Source S ON T.Id = S.Id WHEN MATCHED THEN UPDATE SET T.Val = S.Val WHEN NOT MATCHED THEN INSERT (Id, Val) VALUES (S.Id, S.Val); END";
            var obj = new DbObject("testmerge", ObjectType.Procedure, mssql, false, "OK");
            string pg = Converter.Convert(obj, "postgres");

            // Should either map to PG MERGE or raise a valid warning
            Assert.That(pg, Does.Contain("MERGE INTO")
                .Or.Contain("ON CONFLICT")
                .Or.Contain("TODO: MERGE"));
        }

        // ─── 4. RAISERROR mapping ────────────────────────────────────────────
        [Test]
        public void TestRAISERROR()
        {
            string mssql = "CREATE PROCEDURE dbo.TestRaiserror AS BEGIN RAISERROR('Error message', 16, 1) END";
            var obj = new DbObject("testraiserror", ObjectType.Procedure, mssql, false, "OK");
            string pg = Converter.Convert(obj, "postgres");

            Assert.That(pg, Does.Contain("RAISE EXCEPTION"));
            Assert.That(pg, Does.Not.Contain("RAISERROR"));
        }

        // ─── 5. TRY/CATCH mapping ────────────────────────────────────────────
        [Test]
        public void TestTRY_CATCH()
        {
            string mssql = "CREATE PROCEDURE dbo.TestTryCatch AS BEGIN BEGIN TRY UPDATE Tab SET A = 1; END TRY BEGIN CATCH ROLLBACK TRAN; END CATCH END";
            var obj = new DbObject("testtrycatch", ObjectType.Procedure, mssql, false, "OK");
            string pg = Converter.Convert(obj, "postgres");

            Assert.That(pg, Does.Contain("EXCEPTION WHEN OTHERS THEN"));
            Assert.That(pg, Does.Not.Contain("BEGIN TRY"));
            Assert.That(pg, Does.Not.Contain("BEGIN CATCH"));
        }

        // ─── 6. CURSOR mapping ───────────────────────────────────────────────
        [Test]
        public void TestCURSOR()
        {
            string mssql = "CREATE PROCEDURE dbo.TestCursorSimple AS BEGIN DECLARE c CURSOR FOR SELECT X FROM Y; OPEN c; FETCH NEXT FROM c INTO @v; CLOSE c; DEALLOCATE c; END";
            var obj = new DbObject("testcursorsimple", ObjectType.Procedure, mssql, false, "OK");
            string pg = Converter.Convert(obj, "postgres");

            Assert.That(pg, Does.Not.Contain("OPEN c"));
            Assert.That(pg, Does.Not.Contain("FETCH NEXT FROM"));
        }

        // ─── 7. XML parsing mapping ──────────────────────────────────────────
        [Test]
        public void TestXML()
        {
            string mssql = "CREATE PROCEDURE dbo.TestXMLSimple AS BEGIN SELECT * FROM OPENXML(@doc, '/path') WITH (A INT) END";
            var obj = new DbObject("testxmlsimple", ObjectType.Procedure, mssql, false, "OK");
            string pg = Converter.Convert(obj, "postgres");

            Assert.That(pg, Does.Contain("xmltable"));
            Assert.That(pg, Does.Not.Contain("OPENXML"));
        }

        [Test]
        public void TestOpenXmlStubKeepsParenthesizedTypesInsideXmlTable()
        {
            string mssql = "CREATE PROCEDURE dbo.TestXMLColumns AS BEGIN " +
                "EXEC sp_xml_preparedocument @doc OUTPUT, @xml\n" +
                "SELECT * INTO #tb FROM OPENXML(@doc, '/root/items') " +
                "WITH (Id INT, AlarmCode VARCHAR(50), Title NVARCHAR(100))\n" +
                "EXEC sp_xml_removedocument @doc END";
            var obj = new DbObject("testxmlcolumns", ObjectType.Procedure, mssql, false, "OK");
            string pg = Converter.Convert(obj, "postgres");

            Assert.That(pg, Does.Contain("NULL::integer AS Id, NULL::text AS AlarmCode, NULL::text AS Title"));
            Assert.That(pg, Does.Contain("replace with xmltable"));
            Assert.That(pg, Does.Not.Contain("sp_xml_preparedocument"));
            Assert.That(pg, Does.Not.Contain("sp_xml_removedocument"));
            Assert.That(pg, Does.Not.Match(@"\)\s*,\s*AlarmCode"));
        }

        [Test]
        public void TestXmlNodesValueBlockBecomesCompileSafeTypedStub()
        {
            string mssql = "CREATE PROCEDURE dbo.TestXMLNodes AS BEGIN " +
                "SELECT X.value('Id','INT') AS Id, X.value('(Title/text())[1]','text') AS Title, " +
                "X.value('(ContentJson/text())[1]','text') AS ContentJson " +
                "INTO #tb2 FROM @xml.nodes('/root/item') AS T(X) END";
            var obj = new DbObject("testxmlnodes", ObjectType.Procedure, mssql, false, "OK");
            string pg = Converter.Convert(obj, "postgres");

            Assert.That(pg, Does.Contain("NULL::integer AS Id"));
            Assert.That(pg, Does.Contain("NULL::text AS Title"));
            Assert.That(pg, Does.Not.Contain(".nodes("));
            Assert.That(pg, Does.Not.Contain(".value("));
        }

        [Test]
        public void TestCteTempMaterializationStaysAttachedBeforeReturnQuery()
        {
            string mssql = "CREATE PROCEDURE dbo.Board_TestCteReturn AS BEGIN\n" +
                "CREATE TEMP TABLE items ON COMMIT DROP AS WITH cte AS (\n" +
                "SELECT 1 AS Id\n)\n" +
                "-- materialize the CTE result\n" +
                "SELECT * FROM cte\nEND";
            var obj = new DbObject("Board_TestCteReturn", ObjectType.Procedure, mssql, false, "OK");
            string pg = Converter.Convert(obj, "postgres");

            Assert.That(pg, Does.Not.Match(@"\)\s*;\s*RETURN\s+QUERY"));
            Assert.That(pg, Does.Match(@"CREATE\s+TEMP\s+TABLE\s+items[\s\S]*?WITH(?:\s+RECURSIVE)?\s+cte[\s\S]*?\)[\s\S]*?\bSELECT\s+\*\s+FROM\s+cte"));
        }

        [Test]
        public void TestCteClosingParenthesisStaysAttachedToDml()
        {
            string mssql = "CREATE PROCEDURE dbo.Board_TestCteUpdate AS BEGIN\n" +
                "WITH cte AS (SELECT 1 AS Id)\n" +
                "UPDATE Target SET Value = 1 WHERE Id IN (SELECT Id FROM cte)\nEND";
            var obj = new DbObject("Board_TestCteUpdate", ObjectType.Procedure, mssql, false, "OK");
            string pg = Converter.Convert(obj, "postgres");

            Assert.That(pg, Does.Not.Match(@"\)\s*;\s*UPDATE\b"));
            Assert.That(pg, Does.Match(@"\)\s*\n\s*UPDATE\b"));
        }

        [Test]
        public void TestNormalParenthesizedExpressionStillTerminatesBeforeDml()
        {
            string mssql = "CREATE PROCEDURE dbo.Board_TestParenBoundary AS BEGIN\n" +
                "SELECT (1 + 2)\n" +
                "UPDATE Target SET Value = 3\nEND";
            var obj = new DbObject("Board_TestParenBoundary", ObjectType.Procedure, mssql, false, "OK");
            string pg = Converter.Convert(obj, "postgres");

            Assert.That(pg, Does.Match(@"SELECT\s+\(1\s*\+\s*2\)\s*;\s*UPDATE\b"));
        }

        // ─── 8. IDENTITY DDL mapping ─────────────────────────────────────────
        [Test]
        public void TestIDENTITY()
        {
            string mssql = "CREATE TABLE dbo.TestIdentityTable (Id INT IDENTITY(1,1))";
            var obj = new DbObject("TestIdentityTable", ObjectType.Table, mssql, false, "OK");
            string pg = Converter.Convert(obj, "postgres");

            Assert.That(pg, Does.Contain("Id serial"));
            Assert.That(pg, Does.Not.Contain("IDENTITY"));
        }

        // ─── 9. Table Variables mapping ──────────────────────────────────────
        [Test]
        public void TestTableVariables()
        {
            string mssql = "CREATE PROCEDURE dbo.TestTableVar AS BEGIN DECLARE @t TABLE (Id INT, Name VARCHAR(50)); INSERT INTO @t VALUES (1, 'A'); END";
            var obj = new DbObject("testtablevar", ObjectType.Procedure, mssql, false, "OK");
            string pg = Converter.Convert(obj, "postgres");

            Assert.That(pg, Does.Contain("CREATE TEMP TABLE"));
            Assert.That(pg, Does.Not.Contain("TABLE ("));
            Assert.That(pg, Does.Not.Contain("@t"));
        }

        // ─── 10. Dynamic SQL mapping ─────────────────────────────────────────
        [Test]
        public void TestDynamicSQL()
        {
            string mssql = "CREATE PROCEDURE dbo.TestDynamic AS BEGIN EXEC('SELECT 1'); EXEC sp_executesql N'SELECT 2'; END";
            var obj = new DbObject("testdynamic", ObjectType.Procedure, mssql, false, "OK");
            string pg = Converter.Convert(obj, "postgres");

            Assert.That(pg, Does.Contain("EXECUTE"));
            Assert.That(pg, Does.Not.Contain("sp_executesql"));
        }

        // ─── 11. Temp Tables DDL mapping ─────────────────────────────────────
        [Test]
        public void TestTempTables()
        {
            string mssql = "CREATE PROCEDURE dbo.TestTemp AS BEGIN CREATE TABLE #t (Col INT); INSERT INTO #t VALUES (1); END";
            var obj = new DbObject("testtemp", ObjectType.Procedure, mssql, false, "OK");
            string pg = Converter.Convert(obj, "postgres");

            Assert.That(pg, Does.Contain("CREATE TEMP TABLE t"));
            Assert.That(pg, Does.Not.Contain("#t"));
        }

        // ─── 12. Recursive CTE mapping ───────────────────────────────────────
        [Test]
        public void TestRecursiveCTE()
        {
            string mssql = "CREATE PROCEDURE dbo.TestRecursive AS BEGIN WITH cte AS (SELECT 1 AS n UNION ALL SELECT n+1 FROM cte WHERE n < 5) SELECT * FROM cte; END";
            var obj = new DbObject("testrecursive", ObjectType.Procedure, mssql, false, "OK");
            string pg = Converter.Convert(obj, "postgres");

            Assert.That(pg, Does.Contain("WITH RECURSIVE cte"));
            Assert.That(pg, Does.Not.Contain("WITH cte AS"));
        }
    }
}
