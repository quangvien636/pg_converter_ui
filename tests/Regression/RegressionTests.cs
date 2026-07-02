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

        [Test]
        public void TestEmptyNumericParameterDefaultBecomesNull()
        {
            string mssql = "CREATE PROCEDURE dbo.Contacts_TestDefault @userNo INT = '' AS BEGIN SELECT @userNo END";
            var obj = new DbObject("Contacts_TestDefault", ObjectType.Procedure, mssql, true, "OK");
            string pg = Converter.Convert(obj, "postgres");

            Assert.That(pg, Does.Contain("userno integer DEFAULT NULL"));
            Assert.That(pg, Does.Not.Contain("integer DEFAULT ''"));
        }

        [Test]
        public void TestOutputParameterWithResultSetUsesInputMode()
        {
            string mssql = "CREATE PROCEDURE dbo.Contacts_TestOutput @seq INT OUTPUT AS BEGIN SELECT @seq END";
            var obj = new DbObject("Contacts_TestOutput", ObjectType.Procedure, mssql, true, "OK");
            string pg = Converter.Convert(obj, "postgres");

            Assert.That(pg, Does.Contain("IN seq integer"));
            Assert.That(pg, Does.Not.Contain("INOUT seq integer"));
            Assert.That(pg, Does.Contain("OUTPUT parameter treated as input"));
        }

        [Test]
        public void TestContactElseBlockGetsEndIf()
        {
            string mssql = """
                CREATE PROCEDURE dbo.Contact_TestBlock @userNo INT
                AS
                BEGIN
                    IF @userNo = 0
                    BEGIN
                        SELECT 0
                    END
                    ELSE
                    BEGIN
                        UPDATE ContactsGroup SET GroupName = GroupName WHERE RegUserNo = @userNo
                    END
                END
                """;
            var obj = new DbObject("Contact_TestBlock", ObjectType.Procedure, mssql, true, "OK");
            string pg = Converter.Convert(obj, "postgres");

            Assert.That(pg, Does.Contain("END IF;"));
            Assert.That(pg, Does.Not.Match(@"(?m)^\s*END;\s*\nEND;"));
        }

        [Test]
        public void TestContactTopAssignmentIsReordered()
        {
            string mssql = """
                CREATE PROCEDURE dbo.Contact_TestTop @parentNo INT
                AS
                BEGIN
                    DECLARE @sort INT
                    SELECT TOP 1 @sort = Sort
                    FROM Contact_ShareGroup
                    WHERE ParentNo = @parentNo
                    ORDER BY Sort DESC
                    SELECT @sort
                END
                """;
            var obj = new DbObject("Contact_TestTop", ObjectType.Procedure, mssql, true, "OK");
            string pg = Converter.Convert(obj, "postgres");

            Assert.That(pg, Does.Contain("SELECT Sort INTO sort FROM Contact_ShareGroup"));
            Assert.That(pg, Does.Not.Contain("LIMIT 1\nWHERE"));
            Assert.That(pg, Does.Not.Contain("TOP 1"));
        }

        [Test]
        public void TestContactStringAccumulation()
        {
            string mssql = """
                CREATE PROCEDURE dbo.Contacts_TestConcat
                AS
                BEGIN
                    DECLARE @query NVARCHAR(MAX)
                    SET @query += ' WHERE Enabled = 1'
                    SELECT @query
                END
                """;
            var obj = new DbObject("Contacts_TestConcat", ObjectType.Procedure, mssql, true, "OK");
            string pg = Converter.Convert(obj, "postgres");

            Assert.That(pg, Does.Contain("query := COALESCE(query, '')"));
            Assert.That(pg, Does.Not.Contain("SET query +="));
        }

        [Test]
        public void TestExecProcedureWithLiteralArguments()
        {
            string mssql = """
                CREATE PROCEDURE dbo.Contacts_TestExec @userNo INT
                AS
                BEGIN
                    EXEC Contacts_InsertGroup @userNo, 'Temporary group', 0
                    SELECT @userNo
                END
                """;
            var obj = new DbObject("Contacts_TestExec", ObjectType.Procedure, mssql, true, "OK");
            string pg = Converter.Convert(obj, "postgres");

            Assert.That(pg, Does.Contain("PERFORM contacts_insertgroup(userNo, 'Temporary group', 0);"));
            Assert.That(pg, Does.Not.Match(@"\bEXEC\s+Contacts_InsertGroup"));
        }

        [Test]
        public void TestContactHeaderCommentKeepsParameter()
        {
            string mssql = """
                -- metadata
                CREATE PROCEDURE [dbo].[Contacts_DeleteHistory]
                    -- Add the parameters for the stored procedure here
                    @HistoryNoList NVARCHAR(MAX)
                AS
                BEGIN
                    DELETE FROM ContactsHistory WHERE HistoryNo = @HistoryNoList
                END
                """;
            var obj = new DbObject("Contacts_DeleteHistory", ObjectType.Procedure, mssql, true, "OK");
            string pg = Converter.Convert(obj, "postgres");

            Assert.That(pg, Does.Contain("IN historynolist character varying"));
        }

        [Test]
        public void TestContactCteFlowsIntoUpdate()
        {
            string mssql = """
                CREATE PROCEDURE dbo.Contacts_TestCte
                AS
                BEGIN
                    ;WITH A AS (SELECT Id FROM SourceTable),
                    B AS (SELECT Id FROM A)
                    UPDATE TargetTable SET Value = 1 FROM B WHERE TargetTable.Id = B.Id
                END
                """;
            var obj = new DbObject("Contacts_TestCte", ObjectType.Procedure, mssql, true, "OK");
            string pg = Converter.Convert(obj, "postgres");

            Assert.That(pg, Does.Not.Match(@"\)\s*;\s*\n\s*UPDATE"));
            Assert.That(pg, Does.Match(@"(?s)WITH(?:\s+RECURSIVE)?\s+A.+UPDATE\s+TargetTable"));
        }

        [Test]
        public void TestInlineCommentDoesNotSwallowSelectTerminator()
        {
            string mssql = """
                CREATE PROCEDURE dbo.Contacts_TestComment
                AS
                BEGIN
                    SELECT GroupNo FROM ContactsGroup WHERE GroupNo = 1 -- old condition
                END
                """;
            var obj = new DbObject("Contacts_TestComment", ObjectType.Procedure, mssql, true, "OK");
            string pg = Converter.Convert(obj, "postgres");

            Assert.That(pg, Does.Match(@"GroupNo\s*=\s*1;"));
        }

        [Test]
        public void TestContactMultipleResultSetsAreTerminated()
        {
            string mssql = """
                CREATE PROCEDURE dbo.Contacts_TestResults @userNo INT
                AS
                BEGIN
                    SELECT Id FROM ContactsAddress WHERE UserNo = @userNo
                    SELECT Id FROM ContactsEmail WHERE UserNo = @userNo
                END
                """;
            var obj = new DbObject("Contacts_TestResults", ObjectType.Procedure, mssql, true, "OK");
            string pg = Converter.Convert(obj, "postgres");

            Assert.That(pg, Does.Match(@"UserNo\s*=\s*contacts_testresults\.userno;\s*\n\s*RETURN QUERY"));
        }

        [Test]
        public void TestSchemaQualifiedExecProcedure()
        {
            string mssql = """
                CREATE PROCEDURE dbo.Contacts_TestSchemaExec @userNo INT
                AS
                BEGIN
                    EXEC dbo.Contacts_SaveHistory @userNo, 'DEL'
                END
                """;
            var obj = new DbObject("Contacts_TestSchemaExec", ObjectType.Procedure, mssql, true, "OK");
            string pg = Converter.Convert(obj, "postgres");

            Assert.That(pg, Does.Contain("PERFORM contacts_savehistory(userNo, 'DEL');"));
            Assert.That(pg, Does.Not.Contain("EXEC public."));
        }

        [Test]
        public void TestMultilineDeclareVariablesAreCollected()
        {
            string mssql = """
                CREATE PROCEDURE dbo.Contacts_TestDeclare
                AS
                BEGIN
                    DECLARE
                    @UserNo INT,
                    @IsPhoneDef CHAR(1) = '0',
                    @DefValue CHAR(1) = '0'
                    SELECT @UserNo
                END
                """;
            var obj = new DbObject("Contacts_TestDeclare", ObjectType.Procedure, mssql, true, "OK");
            string pg = Converter.Convert(obj, "postgres");

            Assert.That(pg, Does.Contain("userno integer;"));
            Assert.That(pg, Does.Contain("isphonedef character varying;"));
            Assert.That(pg, Does.Contain("defvalue character varying;"));
            Assert.That(pg, Does.Not.Match(@"(?m)^\s*@?IsPhoneDef\s+CHAR"));
        }

        [Test]
        public void TestCharIndexCommaLiteral()
        {
            string mssql = """
                CREATE PROCEDURE dbo.Contacts_TestCharIndex
                AS
                BEGIN
                    DECLARE @Items NVARCHAR(MAX)
                    WHILE CHARINDEX(',', @Items) > 0
                    BEGIN
                        SET @Items = SUBSTRING(@Items, CHARINDEX(',', @Items) + 1, LEN(@Items))
                    END
                END
                """;
            var obj = new DbObject("Contacts_TestCharIndex", ObjectType.Procedure, mssql, true, "OK");
            string pg = Converter.Convert(obj, "postgres");

            Assert.That(pg, Does.Contain("STRPOS(Items, ',')"));
            Assert.That(pg, Does.Not.Contain("STRPOS(',Items, ')"));
            Assert.That(pg, Does.Contain("LENGTH(Items)"));
            Assert.That(pg, Does.Not.Contain("LEN(Items)"));
        }

        [Test]
        public void TestTwoArgumentConvertVarchar()
        {
            string mssql = "CREATE PROCEDURE dbo.Contacts_TestConvert AS BEGIN SELECT CONVERT(VARCHAR(10), 42) END";
            var obj = new DbObject("Contacts_TestConvert", ObjectType.Procedure, mssql, true, "OK");
            string pg = Converter.Convert(obj, "postgres");

            Assert.That(pg, Does.Contain("CAST(42 AS text)"));
            Assert.That(pg, Does.Not.Contain("CONVERT(VARCHAR"));
        }

        [Test]
        public void TestTinyIntInsideTempTableBody()
        {
            string mssql = """
                CREATE PROCEDURE dbo.Contacts_TestTinyInt
                AS
                BEGIN
                    CREATE TABLE #Items (Type TINYINT)
                END
                """;
            var obj = new DbObject("Contacts_TestTinyInt", ObjectType.Procedure, mssql, true, "OK");
            string pg = Converter.Convert(obj, "postgres");

            Assert.That(pg, Does.Contain("Type smallint"));
            Assert.That(pg, Does.Not.Contain("TINYINT"));
        }

        [Test]
        public void TestBeginWithCommentIsSuppressedAfterElse()
        {
            string mssql = """
                CREATE PROCEDURE dbo.Contacts_TestElseComment @enabled BIT
                AS
                BEGIN
                    IF @enabled = 1
                    BEGIN -- enabled branch
                        SELECT 1
                    END
                    ELSE
                    BEGIN -- disabled branch
                        SELECT 0
                    END
                END
                """;
            var obj = new DbObject("Contacts_TestElseComment", ObjectType.Procedure, mssql, true, "OK");
            string pg = Converter.Convert(obj, "postgres");

            Assert.That(pg, Does.Not.Match(@"(?m)^\s*BEGIN\s+--"));
            Assert.That(pg, Does.Contain("END IF;"));
        }

        [Test]
        public void TestSingleStatementElseIfClosesBeforeLoopEnd()
        {
            string mssql = """
                CREATE PROCEDURE dbo.Contacts_TestInlineChain
                AS
                BEGIN
                    DECLARE @i INT
                    WHILE @i < 3
                    BEGIN
                        IF @i = 0
                            SET @i = 1
                        ELSE IF @i = 1
                            SET @i = 2
                        ELSE IF @i = 2
                            SET @i = 3
                    END
                END
                """;
            var obj = new DbObject("Contacts_TestInlineChain", ObjectType.Procedure, mssql, true, "OK");
            string pg = Converter.Convert(obj, "postgres");

            Assert.That(pg, Does.Match(@"(?s)ELSIF.+i := 3;.+END IF;.+END LOOP;"));
        }

        [Test]
        public void TestPrintParenthesizedExpression()
        {
            string mssql = """
                CREATE PROCEDURE dbo.Contacts_TestPrint
                AS
                BEGIN
                    PRINT('loop')
                END
                """;
            var obj = new DbObject("Contacts_TestPrint", ObjectType.Procedure, mssql, true, "OK");
            string pg = Converter.Convert(obj, "postgres");

            Assert.That(pg, Does.Contain("RAISE NOTICE '%', 'loop';"));
            Assert.That(pg, Does.Not.Contain("PRINT("));
        }

        [Test]
        public void TestElseWithCommentDoesNotCreatePlainBlock()
        {
            string mssql = """
                CREATE PROCEDURE dbo.Contacts_TestElseLineComment @mode INT
                AS
                BEGIN
                    IF @mode = 0
                    BEGIN
                        SELECT 0
                    END
                    ELSE -- update branch
                    BEGIN
                        UPDATE ContactsUser SET UseYn = 'N'
                    END
                END
                """;
            var obj = new DbObject("Contacts_TestElseLineComment", ObjectType.Procedure, mssql, true, "OK");
            string pg = Converter.Convert(obj, "postgres");

            Assert.That(pg, Does.Not.Match(@"(?s)ELSE\s*\n\s*BEGIN\b"));
            Assert.That(pg, Does.Contain("END IF;"));
        }

        [Test]
        public void TestMultilineStringAccumulationStartingWithPlus()
        {
            string mssql = """
                CREATE PROCEDURE dbo.Contacts_TestContinuation
                AS
                BEGIN
                    DECLARE @query NVARCHAR(MAX), @filter NVARCHAR(MAX)
                    SET @query += 'WHERE Enabled = 1'
                        + @filter + ') Q'
                    SELECT @query
                END
                """;
            var obj = new DbObject("Contacts_TestContinuation", ObjectType.Procedure, mssql, true, "OK");
            string pg = Converter.Convert(obj, "postgres");

            Assert.That(pg, Does.Contain("|| filter ||"));
            Assert.That(pg, Does.Not.Match(@"(?m)^\s*\+\s*filter"));
        }

        [Test]
        public void TestMultilineSpExecuteSqlBindingsDoNotLeakStatements()
        {
            string mssql = """
                CREATE PROCEDURE dbo.Contacts_TestDynamic @userNo INT, @endId INT
                AS
                BEGIN
                    DECLARE @query NVARCHAR(MAX), @params NVARCHAR(MAX)
                    EXECUTE sp_executesql @query, @params, @P_UserNo = @userNo,
                        @P_EndId = @endId
                END
                """;
            var obj = new DbObject("Contacts_TestDynamic", ObjectType.Procedure, mssql, true, "OK");
            string pg = Converter.Convert(obj, "postgres");

            Assert.That(pg, Does.Contain("EXECUTE query;"));
            Assert.That(pg, Does.Contain("TODO: rewrite named sp_executesql bindings"));
            Assert.That(pg, Does.Not.Match(@"(?m)^\s*P_EndId\s*="));
        }

        [Test]
        public void TestDateStyle112Conversion()
        {
            string mssql = """
                CREATE PROCEDURE dbo.TestDate112
                AS
                BEGIN
                    SELECT CONVERT(VARCHAR, RegDate, 112) FROM Table
                END
                """;
            var obj = new DbObject("TestDate112", ObjectType.Procedure, mssql, true, "OK");
            string pg = Converter.Convert(obj, "postgres");

            Assert.That(pg, Does.Contain("TO_CHAR(RegDate, 'YYYYMMDD')"));
            Assert.That(pg, Does.Not.Contain("CAST(RegDate, 112 AS text)"));
        }

        [Test]
        public void TestNamedTransactionStripping()
        {
            string mssql = """
                CREATE PROCEDURE dbo.TestNamedTran
                AS
                BEGIN
                    BEGIN TRANSACTION MyTran -- starts here
                    UPDATE Table SET Col = 1;
                    COMMIT TRANSACTION MyTran -- commits here
                END
                """;
            var obj = new DbObject("TestNamedTran", ObjectType.Procedure, mssql, true, "OK");
            string pg = Converter.Convert(obj, "postgres");

            Assert.That(pg, Does.Not.Contain("MyTran"));
            Assert.That(pg, Does.Not.Contain("TRANSACTION"));
        }

        [Test]
        public void TestDropTableSemicolonInjection()
        {
            string mssql = """
                CREATE PROCEDURE dbo.TestDropTable
                AS
                BEGIN
                    CREATE TABLE #Temp(A INT)
                    DROP TABLE #Temp
                END
                """;
            var obj = new DbObject("TestDropTable", ObjectType.Procedure, mssql, true, "OK");
            string pg = Converter.Convert(obj, "postgres");

            Assert.That(pg, Does.Contain("DROP TABLE Temp;").Or.Contain("DROP TABLE temp;"));
        }

        [Test]
        public void TestElseIfBeginBlockStackTracking()
        {
            string mssql = """
                CREATE PROCEDURE dbo.TestElseIfBegin
                AS
                BEGIN
                    IF 1 = 1
                    BEGIN
                        PRINT('1')
                    END
                    ELSE IF 2 = 2
                    BEGIN
                        PRINT('2')
                    END
                    ELSE
                    BEGIN
                        PRINT('else')
                    END
                END
                """;
            var obj = new DbObject("TestElseIfBegin", ObjectType.Procedure, mssql, true, "OK");
            string pg = Converter.Convert(obj, "postgres");

            // We expect ELSIF block to NOT close the IF statement early.
            // There should be exactly one "END IF;" line.
            var matches = System.Text.RegularExpressions.Regex.Matches(pg, @"\bEND\s+IF\s*;");
            Assert.That(matches.Count, Is.EqualTo(1));
        }







        [Test]
        public void TestNestedIfBlockClosure()
        {
            string mssql = """
                CREATE PROCEDURE dbo.TestNestedIfBlock
                AS
                BEGIN
                    IF 1 = 1
                    BEGIN
                        IF 2 = 2
                        BEGIN
                            PRINT('inner')
                        END
                        ELSE
                        BEGIN
                            PRINT('inner else')
                        END
                    END
                    ELSE IF 3 = 3
                    BEGIN
                        PRINT('outer else if')
                    END
                END
                """;
            var obj = new DbObject("TestNestedIfBlock", ObjectType.Procedure, mssql, true, "OK");
            string pg = Converter.Convert(obj, "postgres");

            // Outer IF block should contain the inner IF statement.
            // There should be exactly one "END IF;" for the inner block,
            // and exactly one "END IF;" for the outer block at the very end.
            var matches = System.Text.RegularExpressions.Regex.Matches(pg, @"\bEND\s+IF\s*;");
            Assert.That(matches.Count, Is.EqualTo(2));
        }
    }
}
