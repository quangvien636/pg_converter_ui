using pg_converter_ui;

static string ConvertBoard(string name, string body)
{
    var sql = $"""
        CREATE PROCEDURE dbo.{name}
        AS
        BEGIN
        {body}
        END
        """;
    return Converter.Convert(new DbObject(name, ObjectType.Procedure, sql, true, "OK"), "postgres");
}

static void MustContain(string sql, string expected, string test)
{
    if (!sql.Contains(expected, StringComparison.OrdinalIgnoreCase))
        throw new Exception($"{test}: expected output to contain:\n{expected}\n\nActual:\n{sql}");
}

static void MustNotContain(string sql, string unexpected, string test)
{
    if (sql.Contains(unexpected, StringComparison.OrdinalIgnoreCase))
        throw new Exception($"{test}: output unexpectedly contained:\n{unexpected}\n\nActual:\n{sql}");
}

var endElse = ConvertBoard("Board_InsertCurrentManager_Regression", """
    IF (SELECT COUNT(*) FROM Board_UserByGroup) = 0
    BEGIN
        INSERT INTO Board_UserByGroup(USER_NO) VALUES (1)
        SELECT 1
    END
    ELSE
    BEGIN
        SELECT 0
    END
    """);
MustContain(endElse, "ELSE", "END/ELSE block");
MustNotContain(endElse, "END IF;\n    ELSE", "END/ELSE block");
MustNotContain(endElse, "END IF;\r\n    ELSE", "END/ELSE block");
MustContain(endElse, "VALUES (1);", "semicolon before returned SELECT");

var dmlResult = ConvertBoard("Board_Authority_Select_Regression", """
    CREATE TABLE #BelongToDepartments (DepartNo INT)
    INSERT INTO #BelongToDepartments
    SELECT DepartNo FROM Organization_Departments
    SELECT DepartNo FROM #BelongToDepartments
    """);
MustNotContain(dmlResult, "INSERT INTO belongtodepartments\n    RETURN QUERY", "INSERT SELECT result injection");
MustContain(dmlResult, "RETURN QUERY\nSELECT DepartNo FROM belongtodepartments", "standalone result SELECT");

var inlineIf = ConvertBoard("Board_Web_Search_Regression", """
    DECLARE @Query NVARCHAR(MAX)
    IF (@SortColumn = 1) SET @Query = 'RegDate'
    SELECT @Query
    """);
MustNotContain(inlineIf, "SET Query = 'RegDate' THEN", "inline IF statement");

var selectAssignment = ConvertBoard("Board_DownBoardByUser_Regression", """
    DECLARE @UpNo INT, @IsBoard BIT
    SELECT TOP 1 @UpNo = T.SortNo, @IsBoard = T.IsBoard
    FROM TempUpdate T
    SELECT @UpNo
    """);
MustContain(selectAssignment, "SELECT T.SortNo, T.IsBoard INTO upno, isboard", "TOP SELECT assignment");
MustNotContain(selectAssignment, "TOP 1", "TOP SELECT assignment");
MustNotContain(selectAssignment, "UpNo =", "TOP SELECT assignment");

var dynamicTop = ConvertBoard("Board_Web_Search_Top_Regression", """
    DECLARE @RecommendedDisplayCount INT
    SELECT TOP (@RecommendedDisplayCount) ContentNo
    FROM Board_Contents
    """);
MustNotContain(dynamicTop, "TOP (", "dynamic TOP");
MustContain(dynamicTop, "SELECT ContentNo", "dynamic TOP");

var outerApply = ConvertBoard("Board_GetListBoardContent_Regression", """
    SELECT T.ContentNo, VL.ViewedCount, R.ReplyCount
    FROM TMP T
    OUTER APPLY (
        SELECT COUNT(*) AS ViewedCount
        FROM Board_ViewedLogs BV
        WHERE BV.ContentNo = T.ContentNo
          AND EXISTS (SELECT 1 FROM Board_Sharers BS WHERE BS.ContentNo = T.ContentNo)
    ) VL
    OUTER APPLY (
        SELECT COUNT(*) AS ReplyCount
        FROM Board_Replies BR
        WHERE BR.ContentNo = T.ContentNo
    ) R
    """);
MustNotContain(outerApply, "OUTER APPLY", "Board OUTER APPLY");
MustContain(outerApply, "LEFT JOIN LATERAL (", "Board OUTER APPLY");
MustContain(outerApply, ") VL ON TRUE", "Board OUTER APPLY alias");
MustContain(outerApply, ") R ON TRUE", "Board OUTER APPLY second alias");

var nestedElseBegin = ConvertBoard("Board_InsertViewedLog_Block_Regression", """
    IF (SELECT COUNT(*) FROM Board_ViewedLogs) > 0
    BEGIN
        SELECT @LogNo = LogNo FROM Board_ViewedLogs
    END
    ELSE
    BEGIN
        UPDATE Board_Contents SET ViewedCount = ViewedCount + 1
        SET @LogNo = SCOPE_IDENTITY()
    END
    SELECT @LogNo
    """);
MustNotContain(nestedElseBegin, "ELSE\n    BEGIN", "ELSE BEGIN binding");
MustNotContain(nestedElseBegin, "ELSE\r\n    BEGIN", "ELSE BEGIN binding");
MustContain(nestedElseBegin, "END IF;", "ELSE BEGIN binding");
MustContain(nestedElseBegin, "FROM Board_ViewedLogs;", "branch terminator");

var nestedIf = ConvertBoard("Board_GetBoards_BK_Block_Regression", """
    IF @IsDisabled = 1
    BEGIN
        IF @IsAdmin = 0
        BEGIN
            SELECT 1
        END
        ELSE
        BEGIN
            SELECT 2
        END
    END
    ELSE
    BEGIN
        SELECT 3
    END
    """);
MustContain(nestedIf, "SELECT 2;\n    END IF;\nELSE", "nested ELSE binding");
MustContain(nestedIf, "END IF;", "nested IF closure");

var stringAccumulation = ConvertBoard("Board_Web_Search_Accumulation_Regression", """
    DECLARE @Query NVARCHAR(MAX), @Where NVARCHAR(MAX)
    SET @Query = NULL
    SET @Query += 'SELECT * FROM Board_Contents '
    SET @Where +=
        ' WHERE Title LIKE ''%' + @SearchText + '%'' ' +
        ' AND Enabled = 1'
    SELECT @Query
    """);
MustNotContain(stringAccumulation, "SET Query +=", "string accumulation");
MustNotContain(stringAccumulation, "SET Where +=", "multiline string accumulation");
MustContain(stringAccumulation,
    "query := COALESCE(query, '') || COALESCE(('SELECT * FROM Board_Contents '), '');",
    "NULL-safe string accumulation");
MustContain(stringAccumulation, "where := COALESCE(where, '') || COALESCE((",
    "multiline NULL-safe accumulation");
MustContain(stringAccumulation, " || searchtext || ", "dynamic concat operator");

var tempLifecycle = ConvertBoard("Board_DownWidget_Temp_Regression", """
    DECLARE @SortTemp INT
    SELECT @SortTemp = Sort FROM Board_NewBoardWidget WHERE BoardNo = @BoardNo
    SELECT TOP 2 No, Sort INTO #WidgetTemp
    FROM Board_NewBoardWidget
    WHERE BoardNo = @BoardNo
    ORDER BY Sort
    UPDATE BW SET Sort = T.Sort
    FROM Board_NewBoardWidget BW
    INNER JOIN #WidgetTemp T ON T.No = BW.No
    DROP TABLE #WidgetTemp
    """);
MustContain(tempLifecycle,
    "CREATE TEMP TABLE WidgetTemp ON COMMIT DROP AS SELECT No, Sort",
    "SELECT INTO temp");
MustNotContain(tempLifecycle, "CREATE TEMP TABLE WidgetTemp AS SELECT Sort INTO",
    "bounded SELECT INTO temp");
MustNotContain(tempLifecycle, "#WidgetTemp", "temp references");
MustContain(tempLifecycle, "DROP TABLE IF EXISTS WidgetTemp;", "temp drop");

var tableVariable = ConvertBoard("Board_Authority_Select_Temp_Regression", """
    DECLARE @Departments TABLE (DepartNo INT, Enabled BIT)
    INSERT INTO @Departments VALUES (1, 1)
    SELECT DepartNo FROM @Departments
    """);
MustContain(tableVariable,
    "CREATE TEMP TABLE Departments (DepartNo INT, Enabled boolean) ON COMMIT DROP;",
    "table variable materialization");
MustNotContain(tableVariable, "@Departments", "table variable references");

var statementBoundaries = ConvertBoard("Board_InsertAndroidDevice_Boundary_Regression", """
    DELETE FROM Board_AndroidDevices WHERE UserNo = @UserNo
    INSERT INTO Board_AndroidDevices(UserNo) VALUES (@UserNo)
    ;
    SET @DeviceNo = SCOPE_IDENTITY()
    SELECT @DeviceNo
    """);
MustContain(statementBoundaries,
    "DELETE FROM Board_AndroidDevices WHERE UserNo = UserNo;",
    "DML boundary before INSERT");
MustNotContain(statementBoundaries, "\n    ;", "orphan semicolon");
MustContain(statementBoundaries, "VALUES (UserNo);", "DML boundary before assignment");

var controlBoundaries = ConvertBoard("Board_UpdateNoticePermission_Boundary_Regression", """
    DELETE FROM Board_NoticePermission
    WHERE UserNo = @UserNo
    IF @AllowValue > 0
    BEGIN
        INSERT INTO Board_NoticePermission(UserNo, AllowValue)
        VALUES (@UserNo, @AllowValue)
    END
    """);
MustContain(controlBoundaries, "WHERE UserNo = UserNo;",
    "boundary before IF");
MustContain(controlBoundaries, "VALUES (UserNo, AllowValue);", "boundary before END IF");

var sqlCaseBoundary = ConvertBoard("Board_GetBoards_Case_Boundary_Regression", """
    SELECT CASE
        WHEN @IsAdmin = 1 THEN AdminCount
        ELSE UserCount
    END AS UnreadCount
    FROM Board_Boards
    """);
MustNotContain(sqlCaseBoundary, "THEN AdminCount;", "SQL CASE boundary");
MustNotContain(sqlCaseBoundary, "ELSE UserCount;", "SQL CASE ELSE boundary");

var insertSelectBoundary = ConvertBoard("Board_SetAllHistoryFolder_Boundary_Regression", """
    INSERT INTO Board_HistoryFolder(UserNo, FolderNo)
    SELECT @UserNo, FolderNo
    FROM Board_Folders
    """);
MustNotContain(insertSelectBoundary, "Board_HistoryFolder(UserNo, FolderNo);",
    "INSERT SELECT boundary");
MustContain(insertSelectBoundary, "FROM Board_Folders;", "INSERT SELECT terminator");

var scalarConvertAssignment = ConvertBoard("Board_SetFolders_Scalar_Regression", """
    DECLARE @LevelRand NVARCHAR(100)
    SELECT @LevelRand = LevelRand + CONVERT(nvarchar(20), FolderNo) + ',' FROM Board_Folders WHERE FolderNo = @ParentNo
    """);
MustContain(scalarConvertAssignment,
    "SELECT LevelRand + CONVERT(nvarchar(20), FolderNo) + ',' INTO levelrand FROM Board_Folders",
    "balanced scalar assignment");
MustNotContain(scalarConvertAssignment, "levelrand := (", "malformed scalar assignment");

var consecutiveScalarSelects = ConvertBoard("Board_DownBoardByUser_Scalar_Regression", """
    DECLARE @CurrentNo INT, @ParentNo INT, @UpNo INT
    SELECT @CurrentNo = SortNo, @ParentNo = FolderNo FROM Board_Boards
    SELECT @UpNo = T.SortNo FROM (SELECT SortNo FROM Board_Boards) T
    """);
MustContain(consecutiveScalarSelects,
    "SELECT SortNo, FolderNo INTO currentno, parentno FROM Board_Boards;",
    "consecutive scalar boundary");
MustNotContain(consecutiveScalarSelects, "SELECT  INTO  FROM", "empty scalar SELECT");

var multilineScalarSelect = ConvertBoard("Board_UpdateConfig_Scalar_Regression", """
    DECLARE @Temp INT
    SELECT @Temp = ConfigNo
    FROM Board_Config
    WHERE ConfigKey = @ConfigKey
    SELECT @Temp
    """);
MustContain(multilineScalarSelect,
    "SELECT ConfigNo INTO temp FROM Board_Config",
    "multiline scalar SELECT");
MustNotContain(multilineScalarSelect, "SELECT  INTO  FROM", "multiline empty SELECT");

var bareEndIf = ConvertBoard("Board_GetHeads_Block_End_Regression", """
    IF @IsDisabled = 1
    BEGIN
        SELECT 1
    END
    ELSE
    BEGIN
        SELECT 2
    END
    END
    """);
MustContain(bareEndIf, "END IF;", "bare END closes IF");
MustNotContain(bareEndIf, "END IF;\nEND;", "duplicate routine END");

var missingEndIf = ConvertBoard("Board_UpdatePermissions_Block_End_Regression", """
    IF @ItemType = 2
    BEGIN
        UPDATE Board_Boards SET Enabled = 1
    END
    """);
MustContain(missingEndIf, "END IF;", "missing END IF closure");

var cteTempMaterialization = ConvertBoard("Board_UpdateSpecType_Temp_Cte_Regression", """
    ;WITH FolderNos AS (
        SELECT FolderNo FROM Board_Folders
    )
    SELECT FolderNo INTO #FolderTemp FROM FolderNos
    SELECT FolderNo FROM #FolderTemp
    """);
MustContain(cteTempMaterialization,
    "CREATE TEMP TABLE FolderTemp ON COMMIT DROP AS WITH FolderNos AS",
    "CTE temp materialization order");
MustNotContain(cteTempMaterialization, ") CREATE TEMP TABLE", "CTE DDL placement");
MustNotContain(cteTempMaterialization,
    "RETURN QUERY\nCREATE TEMP TABLE", "temp materialization result injection");

var balancedTableDefinition = ConvertBoard("Board_GetDepart_Temp_Ddl_Regression", """
    DECLARE @tmp TABLE (
        DepartName NVARCHAR(100),
        PositionName NVARCHAR(100)
    )
    INSERT INTO @tmp VALUES ('A', 'B')
    SELECT * FROM @tmp
    """);
MustContain(balancedTableDefinition,
    "PositionName varchar(100)\n) ON COMMIT DROP;",
    "balanced temp column definition");
MustNotContain(balancedTableDefinition, "varchar(100) ON COMMIT DROP;,",
    "ON COMMIT placement");

var tempIdentity = ConvertBoard("Board_Authority_Temp_Identity_Regression", """
    DECLARE @Rows TABLE (
        RowNum INT IDENTITY,
        DepartNo INT
    )
    SELECT RowNum FROM @Rows
    """);
MustContain(tempIdentity, "integer GENERATED BY DEFAULT AS IDENTITY",
    "temp identity mapping");

var tempDropGuard = ConvertBoard("Board_Tree_Temp_Drop_Regression", """
    IF OBJECT_ID('tempdb..#T') IS NOT NULL DROP TABLE #T
    CREATE TABLE #T (No INT)
    DROP TABLE #T
    """);
MustContain(tempDropGuard, "DROP TABLE IF EXISTS T;", "OBJECT_ID temp drop");
MustNotContain(tempDropGuard, "DROP TABLE IF EXISTS IF", "double temp drop rewrite");

var (allObjects, loadError) = MssqlDbReader.Load(
    "221.148.141.4,14233", "CrewCloud_Company_Bootstrap", false, "dazone", "crewcloud12!@",
    inclFunc: true, inclTable: true, inclIndex: false);
var proc = allObjects.First(o => o.Name == "Board_DeleteDepartAllowAccess");
var bodyNoDecl = Converter.ExtractRoutineBody(proc.RawBlock);
var stage1 = BodyConverter.Convert(bodyNoDecl, proc.Name);
var stage2 = Converter.Convert(proc, "postgres", tableCatalog);
Console.WriteLine("STAGE 1 (BodyConverter.Convert):\n" + stage1);
Console.WriteLine("\n=========================================\n");
Console.WriteLine("STAGE 2 (Final Converter.Convert):\n" + stage2);
throw new Exception("DEBUG EXIT");
