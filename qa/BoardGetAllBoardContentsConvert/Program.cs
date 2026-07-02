using pg_converter_ui;

// Re-convert Board_GetAllBoardContents straight from the real MSSQL
// stored procedure source (captured verbatim from sys.sql_modules
// export at C:\Temp\ms_extract\Board_MSSQL_Export.sql, lines 1673-1971)
// through pg_converter_ui's own Converter/BodyConverter, to see whether
// the tool reproduces the same bugs that were hand-fixed in the live
// PostgreSQL function (42725 not-unique overload was pre-existing DB
// drift and is out of scope here; this checks the *body conversion*
// bugs: ambiguous userno/isalarm columns, BIT =1/=0 vs boolean columns,
// and the ParseJson() call with no PG equivalent).
const string mssqlSource = """
CREATE PROCEDURE [dbo].[Board_GetAllBoardContents]
	@UserNo			int=70,
	@SortColumn			INT=1,
	@IsAscending		BIT=0,
	@CountPerPage		INT=10,
	@CurrentPageIndex	INT=1,
	@LanguageSign		nvarchar(5)='KO',
	@FilterType  INT=100,
	@ViewMode int =-1,
	@FromDate Datetime='2000-01-01 00:00:00',
	@ToDate DateTime='2028-11-29 11:09:58.860',
	@TypeEff int =1,
	@IsAlarm BIT = 0,
	@IsAdmin BIT = 1,
	@SearchType INT=0,
	@SearchValue NVARCHAR(200)=N''
AS

BEGIN
WITH PERMISSION AS (
	Select *
	FROM Board_AllowAccess
	WHERE ItemType=2 AND UserNo=@UserNo
),
DEPARTPERMISSION AS (
	Select ItemNo ,AllowValue,AllowAccessNo
	FROM Board_DepartAllowAccess BD
	INNER JOIN Organization_BelongToDepartment OB ON OB.DepartNo=BD.DepartNo
	WHERE BD.ItemType=2 AND OB.UserNo=@UserNo AND OB.IsDefault='TRUE'
),
SHARE AS(
	SELECT U.UserNo ,BS.ContentNo ,ROW_NUMBER() OVER(PARTITION BY BS.ContentNo  ORDER BY BS.ContentNo ASC) AS Rn
	FROM Board_Sharers BS
	INNER JOIN (
		SELECT U.UserNo,OP.DepartNo
		FROM Organization_Users U
		INNER JOIN Organization_BelongToDepartment OP ON OP.UserNo=U.UserNo
		WHERE U.UserNo=@UserNo --AND U.[Enabled]=1
		) U ON U.UserNo=BS.UserNo OR U.DepartNo=BS.DepartNo
),
REP AS (SELECT BC.ContentNo,Count(BR.ReplyNo) AS ReplyCount
	FROM Board_Contents BC
	LEFT JOIN Board_Replies BR ON BR.ContentNo=BC.ContentNo
	WHERE BC.[Enabled]=1
	GROUP BY BC.ContentNo
	),
VIEWED AS (SELECT DISTINCT UserNo,ContentNo
FROM Board_ViewedLogs
WHERE UserNo=@UserNo),
TMP AS (
	SELECT BC.*,T.Url AS FileUrl,
	CASE WHEN CHARINDEX('{', B.Name)>0 THEN (SELECT TOP(1) StringValue FROM ParseJson(B.Name)  WHERE NAME=@LanguageSign) ELSE B.Name END AS BoardName ,
	CASE @LanguageSign WHEN 'EN' THEN  ISNULL(OU.Name_EN,OU.Name) WHEN 'VN' THEN  ISNULL(OU.Name_VN,OU.Name) WHEN 'CH' THEN ISNULL(OU.Name_CH,OU.Name)  WHEN 'JP' THEN ISNULL(OU.Name_JP,OU.Name) ELSE OU.Name END AS RegUserName,
	CASE @LanguageSign WHEN 'EN' THEN  ISNULL(OP.Name_EN,OP.Name) WHEN 'VN' THEN  ISNULL(OP.Name_VN,OP.Name) WHEN 'CH' THEN ISNULL(OP.Name_CH,OP.Name)  WHEN 'JP' THEN ISNULL(OP.Name_JP,OP.Name) ELSE OP.Name END AS RegPositionName,
	CASE @LanguageSign WHEN 'EN' THEN  ISNULL(OD.Name_EN,OD.Name) WHEN 'VN' THEN  ISNULL(OD.Name_VN,OD.Name) WHEN 'CH' THEN ISNULL(OD.Name_CH,OD.Name)  WHEN 'JP' THEN ISNULL(OD.Name_JP,OD.Name) ELSE OD.Name END AS RegDepartName,
	CONVERT(CHAR(16), BC.RegDate, 120) as RegDateToString,
	CASE WHEN BV.ContentNo IS NOT NULL THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END AS IsReaded ,
	ROW_NUMBER() OVER(PARTITION BY BC.[Enabled]  ORDER BY BC.RegDate DESC) AS RowNumber,
	B.ViewMode AS BoardType,
	CASE WHEN @IsAdmin=1 OR P.AllowValue%2<>0 OR D.AllowValue%2<>0 OR BC.RegUserNo=@UserNo THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END AS IsDelete
	FROM BOARD_CONTENTS BC
	LEFT JOIN (SELECT *,ROW_NUMBER() OVER(PARTITION BY ContentNo  ORDER BY ContentNo ASC) AS Rn FROM Board_Files ) T ON T.ContentNo=BC.ContentNo AND Rn=1
	LEFT JOIN Board_Boards B ON B.BoardNo=BC.BoardNo
	LEFT JOIN Organization_Users OU ON OU.UserNo = BC.RegUserNo
	LEFT JOIN Organization_Positions OP ON OP.PositionNo = BC.RegPositionNo
	LEFT JOIN Organization_Departments OD ON OD.DepartNo = BC.RegDepartNO
	LEFT JOIN VIEWED BV ON BV.ContentNo=BC.ContentNo
	LEFT JOIN PERMISSION P ON P.ItemNo=BC.BoardNo
	LEFT JOIN DEPARTPERMISSION D ON D.ItemNo=BC.BoardNo
	LEFT JOIN SHARE S ON S.ContentNo=BC.ContentNo  AND S.Rn=1
	WHERE
	--(BC.BoardNo=@BoardNo OR   (@BoardNo =0 AND B.ViewMode=2)) AND
	BC.[Enabled]=1 AND BC.RegDate>=@FromDate AND BC.RegDate<=@ToDate
	AND (@FilterType=100 OR (@FilterType=1 AND BV.ContentNo IS NULL))
	AND  TitleEffect=@TypeEff
	AND  (@IsAlarm=0 OR (BC.IsAlarm = @IsAlarm AND @IsAlarm=1  AND ISNULL(BC.StartDate,GETDATE())<= GETDATE() AND ISNULL(BC.EndDate,DATEADD(month, 1, GETDATE()))>= GETDATE()  ))
	AND ( @IsAdmin=1 OR BC.RegUserNo=@UserNo OR  ((P.AllowAccessNo IS NOT NULL OR D.AllowAccessNo IS NOT NULL)  AND B.SpecType=0) OR D.AllowAccessNo IS NOT NULL OR((BC.IsShareAll=1  OR S.ContentNo IS NOT NULL) AND  B.SpecType=1))
	AND (ISNULL(@SearchValue,'')='' OR
		 CASE @SearchType
			WHEN 1 THEN BC.Title
			WHEN 2 THEN OD.Name
			WHEN 3 THEN OU.Name
			ELSE BC.Title
		END LIKE '%'+@SearchValue+'%')


) ,

Total AS (Select count(*) as ToTal FROM TMP)
SELECT T.BoardNo,
T.ContentNo ,
T.Title,
T.FileUrl,
T.IsFile,
T.BoardName ,
T.RegUserName,
T.RegPositionName,
T.RegDepartName,
T.ViewedCount ,
T.RegDateToString,
T.RootId,
T.TitleEffect,
T.IsDelete ,
T.IsReaded,
c.Total,
R.ReplyCount,
T.BoardType,
T.RegDate
FROM TMP T
LEFT JOIN Total c ON c.Total>0
--LEFT JOIN PERMISSION P ON P.ItemNo=T.ContentNo


INNER JOIN REP R ON R.ContentNo=T.ContentNo
WHERE --(T.IsShareAll=1 OR @IsAdmin=1 OR P.AllowAccessNo IS NOT NULL OR S.ContentNo IS NOT NULL )  AND
T.RowNumber>(@CurrentPageIndex-1)*@CountPerPage AND T.RowNumber<=@CurrentPageIndex*@CountPerPage
ORDER BY T.RootId DESC,T.ContentNo ASC
END
""";

var obj = new DbObject("Board_GetAllBoardContents", ObjectType.Procedure, mssqlSource, true, "STUB");
var pg = Converter.Convert(obj, "dazone");

Console.WriteLine(pg);
File.WriteAllText("converted_output.sql", pg);
Console.WriteLine();
Console.WriteLine("=== ISSUE SCAN ===");
Console.WriteLine($"contains 'ParseJson(' : {pg.Contains("ParseJson(", StringComparison.OrdinalIgnoreCase)}");
Console.WriteLine($"contains 'Enabled=1' or 'Enabled = 1' : {pg.Contains("Enabled=1") || pg.Contains("Enabled = 1")}");
Console.WriteLine($"contains 'IsAlarm=1' or 'IsAlarm = 1' : {pg.Contains("IsAlarm=1") || pg.Contains("IsAlarm = 1")}");
Console.WriteLine($"contains 'IsShareAll=1' : {pg.Contains("IsShareAll=1") || pg.Contains("IsShareAll = 1")}");
