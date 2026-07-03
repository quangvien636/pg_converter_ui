using NUnit.Framework;
using pg_converter_ui;

namespace RegressionTests;

[TestFixture]
public class ResultMetadataTests
{
    [TestCase("int", "integer")]
    [TestCase("nvarchar(100)", "character varying(100)")]
    [TestCase("varchar(max)", "text")]
    [TestCase("decimal(19,4)", "numeric(19,4)")]
    [TestCase("datetime2(7)", "timestamp without time zone")]
    [TestCase("uniqueidentifier", "uuid")]
    public void MapsSqlServerResultTypes(string sqlServerType, string postgresType)
    {
        Assert.That(SqlServerResultTypeMapper.TryMapToPostgreSql(sqlServerType),
            Is.EqualTo(postgresType));
    }

    [Test]
    public void MetadataJsonRoundTrips()
    {
        var source = new SqlServerResultMetadataExport(
            SqlServerResultMetadataFile.CurrentSchemaVersion,
            DateTimeOffset.Parse("2026-07-03T00:00:00Z"),
            [
                new("board_example", "dbo", "Board_Example", "SQL_STORED_PROCEDURE",
                    "Success", null,
                    [new(1, "BoardNo", "int", false, "integer")])
            ]);

        var json = SqlServerResultMetadataFile.Serialize(source);
        var restored = SqlServerResultMetadataFile.Deserialize(json);

        Assert.That(restored.Routines, Has.Count.EqualTo(1));
        Assert.That(restored.Routines[0].Columns[0].Name, Is.EqualTo("BoardNo"));
        Assert.That(restored.Routines[0].Columns[0].PostgreSqlType, Is.EqualTo("integer"));
        Assert.That(json, Does.Not.Contain("connection"));
    }

    [Test]
    public void RejectsUnknownMetadataSchemaVersion()
    {
        const string json = """{"schemaVersion":999,"generatedAtUtc":"2026-07-03T00:00:00Z","routines":[]}""";
        Assert.Throws<InvalidDataException>(() => SqlServerResultMetadataFile.Deserialize(json));
    }

    [Test]
    public void BuildLookupKeepsOnlySuccessfulRoutinesWithColumns()
    {
        var routines = new List<SqlServerRoutineResultMetadata>
        {
            new("board_example", "dbo", "Board_Example", "SQL_STORED_PROCEDURE",
                "Success", null, [new(1, "BoardNo", "int", false, "integer")]),
            new("board_empty", "dbo", "Board_Empty", "SQL_STORED_PROCEDURE",
                "Success", null, []),
            new("board_failed", "dbo", "Board_Failed", "SQL_STORED_PROCEDURE",
                "Error", "sp_describe_first_result_set 2812: not found", [])
        };

        var lookup = ResultMetadataCatalog.BuildLookup(routines);

        Assert.That(lookup.Keys, Is.EquivalentTo(new[] { "board_example" }));
    }

    // ─── Converter integration ──────────────────────────────────────────────

    [Test]
    public void ProcedureUsesVerifiedMetadataWhenStaticInferenceFails()
    {
        string mssql = "CREATE PROCEDURE dbo.Board_MetadataReturn\r\nAS\r\nBEGIN\r\n    SELECT BoardNo, Title FROM Board_Contents\r\nEND";
        var obj = new DbObject("board_metadatareturn", ObjectType.Procedure, mssql, false, "OK");

        var catalog = ResultMetadataCatalog.BuildLookup(
        [
            new("board_metadatareturn", "dbo", "Board_MetadataReturn", "SQL_STORED_PROCEDURE",
                "Success", null,
                [
                    new(1, "BoardNo", "int", false, "integer"),
                    new(2, "Title", "nvarchar(200)", true, "character varying(200)")
                ])
        ]);

        string pg = Converter.Convert(obj, "postgres", null, catalog);

        Assert.That(pg, Does.Contain("RETURNS TABLE("));
        Assert.That(pg, Does.Contain("boardno integer"));
        Assert.That(pg, Does.Contain("title character varying(200)"));
        Assert.That(pg, Does.Contain("RETURNS TABLE resolved from verified SQL Server result metadata"));
        Assert.That(pg, Does.Not.Contain("SETOF record"));
        Assert.That(pg, Does.Not.Contain("replace SETOF record"));

        // A RETURNS TABLE column name (e.g. boardno) becomes an implicit PL/pgSQL
        // variable visible in the function body. Without #variable_conflict
        // use_column, any unqualified reference to a real column with the same
        // name in a joined query raises "column reference is ambiguous".
        Assert.That(pg, Does.Contain("#variable_conflict use_column"));
    }

    [Test]
    public void ProcedureOmitsVariableConflictPragmaWhenNotReturningTable()
    {
        string mssql = "CREATE PROCEDURE dbo.Board_NoResultSet\r\nAS\r\nBEGIN\r\n    UPDATE Board_Boards SET Enabled = 1\r\nEND";
        var obj = new DbObject("board_noresultset", ObjectType.Procedure, mssql, false, "OK");

        string pg = Converter.Convert(obj, "postgres");

        Assert.That(pg, Does.Contain("RETURNS void"));
        Assert.That(pg, Does.Not.Contain("#variable_conflict"));
    }

    [Test]
    public void ProcedureFallsBackToSetofRecordWhenMetadataColumnTypeUnmapped()
    {
        string mssql = "CREATE PROCEDURE dbo.Board_UnmappedType\r\nAS\r\nBEGIN\r\n    SELECT Geo FROM Board_Contents\r\nEND";
        var obj = new DbObject("board_unmappedtype", ObjectType.Procedure, mssql, false, "OK");

        // A column whose SQL Server type has no trustworthy PostgreSQL mapping
        // (PostgreSqlType left null) must never be guessed.
        var catalog = new Dictionary<string, SqlServerRoutineResultMetadata>(StringComparer.OrdinalIgnoreCase)
        {
            ["board_unmappedtype"] = new("board_unmappedtype", "dbo", "Board_UnmappedType", "SQL_STORED_PROCEDURE",
                "Success", null, [new(1, "Geo", "hierarchyid", false, null)])
        };

        string pg = Converter.Convert(obj, "postgres", null, catalog);

        Assert.That(pg, Does.Contain("SETOF record"));
        Assert.That(pg, Does.Contain("replace SETOF record"));
    }

    [Test]
    public void ProcedureQuotesReservedWordColumnNameFromMetadata()
    {
        string mssql = "CREATE PROCEDURE dbo.Contacts_GetOutList\r\nAS\r\nBEGIN\r\n    SELECT LastName, Position FROM Contacts_Users\r\nEND";
        var obj = new DbObject("contacts_getoutlist", ObjectType.Procedure, mssql, false, "OK");

        var catalog = ResultMetadataCatalog.BuildLookup(
        [
            new("contacts_getoutlist", "dbo", "Contacts_GetOutList", "SQL_STORED_PROCEDURE",
                "Success", null,
                [
                    new(1, "LastName", "nvarchar(50)", true, "character varying(50)"),
                    new(2, "Position", "nvarchar(50)", true, "character varying(50)")
                ])
        ]);

        string pg = Converter.Convert(obj, "postgres", null, catalog);

        Assert.That(pg, Does.Contain("RETURNS TABLE("));
        Assert.That(pg, Does.Contain("\"position\" character varying(50)"));
    }

    [Test]
    public void ProcedureFallsBackToSetofRecordWhenMetadataHasDuplicateColumnNames()
    {
        string mssql = "CREATE PROCEDURE dbo.Board_GetBoardContent\r\nAS\r\nBEGIN\r\n    SELECT IsNotice, IsNotice FROM Board_Contents\r\nEND";
        var obj = new DbObject("board_getboardcontent", ObjectType.Procedure, mssql, false, "OK");

        // SQL Server allows a result set to repeat a column name; PostgreSQL's
        // RETURNS TABLE requires unique column names, so this must not be guessed.
        var catalog = ResultMetadataCatalog.BuildLookup(
        [
            new("board_getboardcontent", "dbo", "Board_GetBoardContent", "SQL_STORED_PROCEDURE",
                "Success", null,
                [
                    new(1, "IsNotice", "bit", false, "boolean"),
                    new(2, "IsNotice", "bit", false, "boolean")
                ])
        ]);

        string pg = Converter.Convert(obj, "postgres", null, catalog);

        Assert.That(pg, Does.Contain("SETOF record"));
        Assert.That(pg, Does.Contain("replace SETOF record"));
    }

    [Test]
    public void ProcedureIgnoresMetadataCatalogWithNoMatchingRoutine()
    {
        string mssql = "CREATE PROCEDURE dbo.Board_NoMetadataMatch\r\nAS\r\nBEGIN\r\n    SELECT BoardNo FROM Board_Contents\r\nEND";
        var obj = new DbObject("board_nometadatamatch", ObjectType.Procedure, mssql, false, "OK");

        var catalog = ResultMetadataCatalog.BuildLookup(
        [
            new("some_other_routine", "dbo", "Some_Other_Routine", "SQL_STORED_PROCEDURE",
                "Success", null, [new(1, "Col", "int", false, "integer")])
        ]);

        string pg = Converter.Convert(obj, "postgres", null, catalog);

        Assert.That(pg, Does.Contain("SETOF record"));
    }
}
