using NUnit.Framework;
using pg_converter_ui;

namespace RegressionTests
{
    [TestFixture]
    public class ConverterRegressionTests
    {
        // ─── 1. Carriage Return \r Semicolon Shielding ───────────────────────
        [Test]
        public void TestCarriageReturnDoubleSemicolon()
        {
            string mssql = "CREATE PROCEDURE dbo.TestCR\r\nAS\r\nBEGIN\r\n    UPDATE Table SET A = 1\r\n    DELETE FROM Table WHERE B = 2\r\nEND";
            var obj = new DbObject("testcr", ObjectType.Procedure, mssql, false, "OK");
            string pg = Converter.Convert(obj, "postgres");

            Assert.That(pg, Does.Contain("UPDATE public.\"Table\" SET A = 1;"));
            Assert.That(pg, Does.Contain("DELETE FROM public.\"Table\" WHERE B = 2;"));
            Assert.That(pg, Does.Not.Contain(";;"));
        }

        // ─── 2. Unconverted Transaction Control ──────────────────────────────
        [Test]
        public void TestUnconvertedTransaction()
        {
            string mssql = "CREATE PROCEDURE dbo.TestTran\r\nAS\r\nBEGIN\r\n    BEGIN TRAN\r\n    UPDATE Table SET A = 1;\r\n    COMMIT TRAN\r\nEND";
            var obj = new DbObject("testtran", ObjectType.Procedure, mssql, false, "OK");
            string pg = Converter.Convert(obj, "postgres");

            Assert.That(pg, Does.Not.Contain("TRAN"));
            Assert.That(pg, Does.Not.Contain("TRANSACTION"));
        }

        // ─── 3. GETDATE() Parameter Defaults Wrapped in Quotes ──────────────
        [Test]
        public void TestGetDateParameterDefault()
        {
            string mssql = "CREATE PROCEDURE dbo.TestGetDate\r\n    @d DATE = GETDATE\r\nAS\r\nBEGIN\r\n    SELECT 1\r\nEND";
            var obj = new DbObject("testgetdate", ObjectType.Procedure, mssql, false, "OK");
            string pg = Converter.Convert(obj, "postgres");

            Assert.That(pg, Does.Contain("DEFAULT CURRENT_DATE").Or.Contain("DEFAULT now()"));
            Assert.That(pg, Does.Not.Contain("'GETDATE'"));
        }

        // ─── 4. SQL Comments inside Parameter Blocks ────────────────────────
        [Test]
        public void TestParameterBlockComment()
        {
            string mssql = "CREATE PROCEDURE dbo.TestParamComment\r\n    -- comment here\r\n    @Param1 INT\r\nAS\r\nBEGIN\r\n    SELECT @Param1\r\nEND";
            var obj = new DbObject("testparamcomment", ObjectType.Procedure, mssql, false, "OK");
            string pg = Converter.Convert(obj, "postgres");

            Assert.That(pg, Does.Contain("param1 integer"));
            Assert.That(pg, Does.Not.Contain("UNPARSED"));
        }

        // ─── 5. Reserved Keyword 'position' Parameter ───────────────────────
        [Test]
        public void TestReservedWordPosition()
        {
            string mssql = "CREATE PROCEDURE dbo.TestPosition\r\n    @position INT\r\nAS\r\nBEGIN\r\n    SELECT @position\r\nEND";
            var obj = new DbObject("testposition", ObjectType.Procedure, mssql, false, "OK");
            string pg = Converter.Convert(obj, "postgres");

            Assert.That(pg, Does.Contain("\"position\" integer"));
        }

        // ─── 6. Unconverted Cursors ──────────────────────────────────────────
        [Test]
        public void TestUnconvertedCursor()
        {
            string mssql = "CREATE PROCEDURE dbo.TestCursor\r\nAS\r\nBEGIN\r\n    DECLARE my_cursor CURSOR FOR SELECT A FROM B\r\n    OPEN my_cursor\r\n    FETCH NEXT FROM my_cursor INTO @val\r\n    CLOSE my_cursor\r\n    DEALLOCATE my_cursor\r\nEND";
            var obj = new DbObject("testcursor", ObjectType.Procedure, mssql, false, "OK");
            string pg = Converter.Convert(obj, "postgres");

            Assert.That(pg, Does.Not.Contain("OPEN my_cursor"));
            Assert.That(pg, Does.Not.Contain("FETCH NEXT FROM"));
            Assert.That(pg, Does.Not.Contain("DEALLOCATE"));
        }

        // ─── 7. Redundant ORDER BY inside UNION branches ────────────────────
        [Test]
        public void TestUnionOrderBy()
        {
            string mssql = "CREATE PROCEDURE dbo.TestUnion\r\nAS\r\nBEGIN\r\n    SELECT A FROM B ORDER BY A DESC UNION ALL SELECT A FROM C ORDER BY A DESC\r\nEND";
            var obj = new DbObject("testunion", ObjectType.Procedure, mssql, false, "OK");
            string pg = Converter.Convert(obj, "postgres");

            // Assert that ORDER BY inside the UNION branch was stripped or parenthesized
            Assert.That(pg, Does.Not.Match(@"ORDER BY\s+\w+\s+(?:DESC|ASC)?\s+UNION\b"));
        }

        // ─── 8. SQL Server Proprietary XML Functions ─────────────────────────
        [Test]
        public void TestXMLOpenXML()
        {
            string mssql = "CREATE PROCEDURE dbo.TestXML\r\nAS\r\nBEGIN\r\n    EXEC sp_xml_preparedocument @docHandle OUTPUT, @xml\r\n    SELECT * FROM OPENXML(@docHandle, '/root') WITH (A INT)\r\nEND";
            var obj = new DbObject("testxml", ObjectType.Procedure, mssql, false, "OK");
            string pg = Converter.Convert(obj, "postgres");

            Assert.That(pg, Does.Not.Contain("sp_xml_preparedocument"));
            Assert.That(pg, Does.Not.Contain("OPENXML"));
        }

        // ─── 9. Comment Shielding: trailing -- inside IF condition ───────────
        [Test]
        public void TestCommentShieldingIfThen()
        {
            // T-SQL inline comment after IF condition must not push THEN into the comment
            string mssql = "CREATE PROCEDURE dbo.TestCommentIf\r\nAS\r\nBEGIN\r\n    IF @x = 1 -- check x\r\n    BEGIN\r\n        SELECT 1\r\n    END\r\nEND";
            var obj = new DbObject("testcommentif", ObjectType.Procedure, mssql, false, "OK");
            string pg = Converter.Convert(obj, "postgres");

            // THEN must appear before the comment, not inside it
            Assert.That(pg, Does.Match(@"IF\s+\w+\s*=\s*1\s+THEN\s*(--|\s|$)"));
            Assert.That(pg, Does.Not.Match(@"THEN\s*$")); // no THEN left dangling after comment
        }

        // ─── 10. Comment Shielding: trailing -- inside WHILE condition ────────
        [Test]
        public void TestCommentShieldingWhileLoop()
        {
            string mssql = "CREATE PROCEDURE dbo.TestCommentWhile\r\nAS\r\nBEGIN\r\n    WHILE @i < 10 -- iterate\r\n    BEGIN\r\n        SET @i = @i + 1\r\n    END\r\nEND";
            var obj = new DbObject("testcommentwhile", ObjectType.Procedure, mssql, false, "OK");
            string pg = Converter.Convert(obj, "postgres");

            Assert.That(pg, Does.Match(@"WHILE\s+\w+\s*<\s*10\s+LOOP"));
            Assert.That(pg, Does.Contain("END LOOP;"));
        }

        // ─── 11. UPDATE SET alias stripping ──────────────────────────────────
        [Test]
        public void TestUpdateSetAliasStrip()
        {
            // T-SQL: UPDATE t SET t.col = val  →  PG: UPDATE t SET col = val
            string mssql = "CREATE PROCEDURE dbo.TestAlias\r\nAS\r\nBEGIN\r\n    UPDATE BW SET BW.Sort = 1, BW.Name = 'A' FROM Board_Widget BW WHERE BW.Id = 1\r\nEND";
            var obj = new DbObject("testalias", ObjectType.Procedure, mssql, false, "OK");
            string pg = Converter.Convert(obj, "postgres");

            Assert.That(pg, Does.Contain("Sort = 1"));
            Assert.That(pg, Does.Contain("Name = 'A'"));
            Assert.That(pg, Does.Not.Match(@"SET\s+\w+\.\w+\s*="));
        }

        // ─── 12. UPDATE SET alias right-side preserved ────────────────────────
        [Test]
        public void TestUpdateSetAliasRightSidePreserved()
        {
            // Alias on the right side of SET assignments must NOT be stripped
            string mssql = "CREATE PROCEDURE dbo.TestAliasRight\r\nAS\r\nBEGIN\r\n    UPDATE BW SET BW.Sort = BW.Sort + 1 FROM Board_Widget BW WHERE BW.Id = 1\r\nEND";
            var obj = new DbObject("testaliasright", ObjectType.Procedure, mssql, false, "OK");
            string pg = Converter.Convert(obj, "postgres");

            Assert.That(pg, Does.Contain("Sort = BW.Sort + 1").Or.Contain("Sort = Sort + 1"));
            Assert.That(pg, Does.Not.Match(@"SET\s+\w+\.\w+\s*="));
        }

        // ─── 13. Duplicate param/var declaration filtered ─────────────────────
        [Test]
        public void TestDuplicateParamVarDeclarationFiltered()
        {
            // MSSQL body re-declares @userNo which is already a parameter — PG must not see a duplicate DECLARE
            string mssql = "CREATE PROCEDURE dbo.TestDupe\r\n    @userNo INT\r\nAS\r\nBEGIN\r\n    DECLARE @userNo INT\r\n    SELECT * FROM Users WHERE UserNo = @userNo\r\nEND";
            var obj = new DbObject("testdupe", ObjectType.Procedure, mssql, false, "OK");
            string pg = Converter.Convert(obj, "postgres");

            // There must be no DECLARE section that declares userno again (parameter already covers it)
            Assert.That(pg, Does.Not.Match(@"(?m)^DECLARE\s*\n.*\buserno\s+integer"));
            Assert.That(pg, Does.Contain("IN userno integer"));
        }

        // ─── 14. Non-duplicate DECLARE var is kept ───────────────────────────
        [Test]
        public void TestNonDuplicateDeclareKept()
        {
            // @tempResult is NOT a parameter — it must remain in DECLARE
            string mssql = "CREATE PROCEDURE dbo.TestNoDupe\r\n    @userNo INT\r\nAS\r\nBEGIN\r\n    DECLARE @tempResult INT\r\n    SELECT @tempResult = COUNT(*) FROM Users WHERE UserNo = @userNo\r\nEND";
            var obj = new DbObject("testnodupe", ObjectType.Procedure, mssql, false, "OK");
            string pg = Converter.Convert(obj, "postgres");

            Assert.That(pg, Does.Contain("tempresult integer"));
            Assert.That(pg, Does.Contain("IN userno integer"));
        }
    }
}
