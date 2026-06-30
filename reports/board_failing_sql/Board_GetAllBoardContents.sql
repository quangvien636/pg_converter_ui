-- ─── PROCEDURE→FUNCTION: board_getallboardcontents ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: Dynamic SQL detected. Manual rewrite required for PostgreSQL.
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: DATEADD was not fully converted; use interval arithmetic
DROP FUNCTION IF EXISTS public.board_getallboardcontents(integer, integer, boolean, integer, integer, character varying, integer, integer, timestamp without time zone, timestamp without time zone, integer, boolean, boolean, integer, character varying);
CREATE OR REPLACE FUNCTION public.board_getallboardcontents(
    IN userno integer DEFAULT 70,
    IN sortcolumn integer DEFAULT 1,
    IN isascending boolean DEFAULT FALSE,
    IN countperpage integer DEFAULT 10,
    IN currentpageindex integer DEFAULT 1,
    IN languagesign character varying DEFAULT 'KO',
    IN filtertype integer DEFAULT 100,
    IN viewmode integer DEFAULT -1,
    IN fromdate timestamp without time zone DEFAULT '2000-01-01 00:00:00',
    IN todate timestamp without time zone DEFAULT '2028-11-29 11:09:58.860',
    IN typeeff integer DEFAULT 1,
    IN isalarm boolean DEFAULT FALSE,
    IN isadmin boolean DEFAULT TRUE,
    IN searchtype integer DEFAULT 0,
    IN searchvalue character varying DEFAULT ''
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

RETURN QUERY
WITH PERMISSION AS (
	Select * 
	FROM Board_AllowAccess 
	WHERE ItemType=2 AND UserNo=board_getallboardcontents.userno
),
DEPARTPERMISSION AS (
	Select ItemNo ,AllowValue,AllowAccessNo 
	FROM Board_DepartAllowAccess BD 
	INNER JOIN Organization_BelongToDepartment OB ON OB.DepartNo=BD.DepartNo
	WHERE BD.ItemType=2 AND OB.UserNo=board_getallboardcontents.userno AND OB.IsDefault= TRUE
),
SHARE AS(
	SELECT U.UserNo ,BS.ContentNo ,ROW_NUMBER() OVER(PARTITION BY BS.ContentNo  ORDER BY BS.ContentNo ASC) AS Rn
	FROM Board_Sharers BS
	INNER JOIN (
		SELECT U.UserNo,OP.DepartNo 
		FROM Organization_Users U 
		INNER JOIN Organization_BelongToDepartment OP ON OP.UserNo=U.UserNo
		WHERE U.UserNo=board_getallboardcontents.userno --AND U.Enabled = TRUE
		) U ON U.UserNo=BS.UserNo OR U.DepartNo=BS.DepartNo
),
REP AS (SELECT BC.ContentNo,Count(BR.ReplyNo) AS ReplyCount
	FROM Board_Contents BC
	LEFT JOIN Board_Replies BR ON BR.ContentNo=BC.ContentNo
	WHERE BC.Enabled = TRUE
	GROUP BY BC.ContentNo
	),
VIEWED AS (SELECT DISTINCT UserNo,ContentNo
FROM Board_ViewedLogs 
WHERE UserNo=board_getallboardcontents.userno),
TMP AS (
	SELECT BC.*,T.Url AS FileUrl,
	CASE WHEN STRPOS(B.Name, '{')>0 THEN (SELECT StringValue FROM ParseJson(B.Name)  WHERE NAME=board_getallboardcontents.languagesign) ELSE B.Name END AS BoardName ,
	CASE LanguageSign WHEN 'EN' THEN  COALESCE(OU.Name_EN,OU.Name) WHEN 'VN' THEN  COALESCE(OU.Name_VN,OU.Name) WHEN 'CH' THEN COALESCE(OU.Name_CH,OU.Name)  WHEN 'JP' THEN COALESCE(OU.Name_JP,OU.Name) ELSE OU.Name END AS RegUserName,
	CASE LanguageSign WHEN 'EN' THEN  COALESCE(OP.Name_EN,OP.Name) WHEN 'VN' THEN  COALESCE(OP.Name_VN,OP.Name) WHEN 'CH' THEN COALESCE(OP.Name_CH,OP.Name)  WHEN 'JP' THEN COALESCE(OP.Name_JP,OP.Name) ELSE OP.Name END AS RegPositionName,
	CASE LanguageSign WHEN 'EN' THEN  COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN  COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name)  WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END AS RegDepartName,
	CONVERT(CHAR(16), BC.RegDate, 120) as RegDateToString,
	CASE WHEN BV.ContentNo IS NOT NULL THEN TRUE ELSE FALSE END AS IsReaded ,
	ROW_NUMBER() OVER(PARTITION BY BC.Enabled  ORDER BY BC.RegDate DESC) AS RowNumber,
	B.ViewMode AS BoardType,
	CASE WHEN IsAdmin = TRUE OR P.AllowValue%2<>0 OR D.AllowValue%2<>0 OR BC.RegUserNo=board_getallboardcontents.userno THEN TRUE ELSE FALSE END AS IsDelete 
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
	--(BC.BoardNo=BoardNo OR   (BoardNo =0 AND B.ViewMode=2)) AND 
	BC.Enabled = TRUE AND BC.RegDate>=board_getallboardcontents.fromdate AND BC.RegDate<=board_getallboardcontents.todate 
	AND (FilterType=100 OR (FilterType=1 AND BV.ContentNo IS NULL))
	AND  TitleEffect=board_getallboardcontents.typeeff
	AND  (IsAlarm = FALSE OR (BC.IsAlarm = board_getallboardcontents.isalarm AND IsAlarm = TRUE  AND COALESCE(BC.StartDate,NOW())<= NOW() AND COALESCE(BC.EndDate,DATEADD(month, 1, NOW()))>= NOW()  ))
	AND ( IsAdmin = TRUE OR BC.RegUserNo=board_getallboardcontents.userno OR  ((P.AllowAccessNo IS NOT NULL OR D.AllowAccessNo IS NOT NULL)  AND B.SpecType=0) OR D.AllowAccessNo IS NOT NULL OR((BC.IsShareAll = TRUE  OR S.ContentNo IS NOT NULL) AND  B.SpecType=1))
	AND (COALESCE(SearchValue,'')='' OR 
		 CASE SearchType 
			WHEN 1 THEN BC.Title 
			WHEN 2 THEN OD.Name   
			WHEN 3 THEN OU.Name  
			ELSE BC.Title   
		END ILIKE '%' || SearchValue || '%')
	

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
WHERE --(T.IsShareAll = TRUE OR IsAdmin = TRUE OR P.AllowAccessNo IS NOT NULL OR S.ContentNo IS NOT NULL )  AND
T.RowNumber>(CurrentPageIndex-1)*CountPerPage AND T.RowNumber<=board_getallboardcontents.currentpageindex*CountPerPage
ORDER BY T.RootId DESC,T.ContentNo ASC;
--	/*
--	 * 쿼리 조합 시작
--	 */

--	DECLARE Query NVARCHAR(2000)
--	SET Query = 'SELECT ROW_NUMBER() OVER (ORDER BY '	
--	DECLARE strAlow NVARCHAR(2000)
--	DECLARE strWriteAlow NVARCHAR(2000)
--	SET strAlow = ''
--	SET strWriteAlow = ''	
--	if (IsAdmin = FALSE)
--	BEGIN
--		SET strAlow = ' LEFT JOIN (SELECT * FROM public."Board_GetBoardAllow"(' || CONVERT(nvarchar(20), UserNo) + ',2)) AC ON BC.BoardNo=AC.BoardNo
--		  LEFT JOIN  (SELECT * FROM public."Board_GetBoardAllow"(' || CONVERT(nvarchar(20), UserNo) + ',4)) AD ON BC.BoardNo=AD.BoardNo 
--		  LEFT JOIN  (SELECT * FROM public."Board_GetBoardAllow"(' || CONVERT(nvarchar(20), UserNo) + ',1)) AE ON BC.BoardNo=AE.BoardNo '	
--		SET strWriteAlow = '(AE.BoardNo IS NOT NULL OR AC.BoardNo IS NOT NULL OR (AD.BoardNo IS NOT NULL AND BC.RegUserNo = ' || CONVERT(nvarchar(10), UserNo) + ' )) AND '
--	END
--	/*
--	 * 정렬 컬럼
--	 */
	 
--	IF (SortColumn <= 1) SET Query += '(CASE WHEN BC.Depth > 0 THEN BC.RootId ELSE BC.ContentNo END) '
--	ELSE IF (SortColumn = 2) SET Query += 'LTRIM(Title) '
--	ELSE IF (SortColumn = 3) SET Query += 'LTRIM(BB.Name) '
--	ELSE IF (SortColumn = 4) SET Query += 'LTRIM(ModUserName) '
--	ELSE IF (SortColumn = 5) SET Query += 'LTRIM(ModDepartName) '
--	ELSE IF (SortColumn  = 6) SET Query += 'ViewedCount '
--	ELSE IF (SortColumn = 7) SET Query += 'IsAlarm '
--	/*
--	 * 정렬 내림차순 여부
--	 */
	 
--	IF (IsAscending = TRUE) SET Query += 'ASC '
--	ELSE SET Query += 'DESC '
	
	
--	SET Query += ', BC.LevelRand + CAST(BC.ContentNo As Nvarchar(20)) ASC, OrderNo ASC'



--	/*
--	 * WHERE 조합 시작
--	 */
		 
--	SET Query +=
--		') RowNum, BC.ContentNo, BC.Content ' +
--		'FROM Board_Contents BC INNER JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo ' || strAlow || 'WHERE ' || strWriteAlow || ' BB.Enabled = TRUE AND  BC.Enabled = TRUE AND ( BC.ViewMode=' || CONVERT(nvarchar(10), ViewMode) + ' OR ' || CONVERT(nvarchar(10), ViewMode) + '< 0) '
	
--	SET Query +=  ' AND ( BC.RegDate >= ''' || CONVERT(nvarchar(20), FromDate) + ''' AND BC.RegDate <= ''' || CONVERT(nvarchar(20), ToDate) + '''  ' 

--	SET Query +=  ' OR (SELECT COUNT(*) FROM Board_Replies BR WHERE BR.ContentNo=BC.ContentNo AND  BR.RegDate >= ''' || CONVERT(nvarchar(20), FromDate) + ''' AND BR.RegDate <= ''' || CONVERT(nvarchar(20), ToDate) + ''' ) > 0 ) ' 

--	IF (TypeEff > 0)
--	BEGIN
--		SET Query += ' AND BC.TitleEffect <> 2 '
--	END

--	IF (IsAlarm > 0)
--	BEGIN
--		SET Query += ' AND BC.IsAlarm = TRUE '
--	END

--    IF (FilterType <> 100)
--	BEGIN
--		SET Query += 'AND BC.RegUserNo <> ' || CONVERT(nvarchar(10), UserNo) + ' AND (Select Count(*) From Board_ViewedLogs where Board_ViewedLogs.UserNo=' || CONVERT(nvarchar(10), UserNo) + ' AND BC.ContentNo=Board_ViewedLogs.ContentNo) <= 0  '
--	END

--	if (IsAdmin = FALSE)  BEGIN

		
--	--SELECT * FROM Board_Sharers BS1 INNER JOIN Organization_BelongToDepartment DP ON DP.DepartNo= BS1.DepartNo WHERE UserNo=222
--	--((SELECT COUNT(*) FROM Board_Sharers BS2 WHERE BS2.CONTENTNO = 16) <=0 )
--		SET Query +=  '  AND ((AE.BoardNo IS NOT NULL  AND BB.SpecType > 1) OR  ( BC.RegUserNo = ' || CONVERT(nvarchar(10), UserNo) + ') OR (BC.ContentNo IN (SELECT BS1.ContentNo FROM Board_Sharers BS1 INNER JOIN public."Organization_GetDepartmentsByUser" (' || CONVERT(nvarchar(10), UserNo) +  ') DP ON DP.DepartNo= BS1.DepartNo)) OR (BC.ContentNo IN ( SELECT BSS1.ContentNo FROM Board_Sharers BSS1
--where BSS1.contentno=BC.ContentNo and BSS1.userno=' || CONVERT(nvarchar(10),UserNo ) +  ')) OR ((SELECT COUNT(*) FROM Board_Sharers BS2 WHERE BS2.CONTENTNO = BC.ContentNO) <=0 ) )'
--		--DECLARE DepartNo INT = (SELECT DepartNo FROM Organization_BelongToDepartment WHERE UserNo = UserNo)
--		--SET Query +=  ' AND ( BC.RegUserNo <> ' || CONVERT(nvarchar(10), UserNo) +' Or ContentNo NOT IN (SELECT distinct ContentNo FROM Board_Sharers WHERE DepartNo <> ' || CONVERT(nvarchar(20), DepartNo) +'))'		
--	END	
--	/*
--	 * 게시글 검색 시작
--	 */
--	DECLARE SearchResult TABLE (
--		RowNum		BIGINT,
--		ContentNo	BIGINT,
--		Content text
--	)
--	PRINT 'Nghiem la ai vay ta' || Query
--	INSERT INTO SearchResult
--	EXEC SP_EXECUTESQL Query
	
		
		
--	/*
--	 * 페이징 계산
--	 */

--	DECLARE TotalItemCount INT
--	DECLARE TotalPageCount INT
--	DECLARE StartRowNum INT
--	DECLARE EndRowNum INT

--	SET TotalItemCount = (SELECT COUNT(*) FROM SearchResult)
--	SET TotalPageCount = TotalItemCount / CountPerPage

--	IF (TotalItemCount % CountPerPage > 0) SET TotalPageCount = TotalPageCount + 1
--	IF (TotalPageCount = 0) SET TotalPageCount = 1
--	--IF (CurrentPageIndex > TotalPageCount) SET CurrentPageIndex = TotalPageCount

--	SET StartRowNum = ((CurrentPageIndex - 1) * CountPerPage) + 1
--	SET EndRowNum = CurrentPageIndex * CountPerPage



--	/*
--	 *
--	 */
	 
--	DECLARE TempTable TABLE (
--		RowNum BIGINT,
--		ContentNo			BIGINT,
--		Content				text,
--		ModUserNo			INT,
--		ModUserName			NVARCHAR(100),
--		ModDepartNo			INT,
--		ModDepartName		NVARCHAR(100),
--		RegDate				DATETIME,
--		Title				NVARCHAR(200),
--		TitleEffect			INT,
--		GroupNo				BIGINT,
--		Depth				INT,
--		OrderNo				INT,
--		HeadNo				INT,
--		IsNotice			BIT,
--		IsFile				BIT,
--		ReplyCount			INT,
--		RecommendedCount	INT,
--		ViewedCount			INT,
		
--		HeadName			NVARCHAR(100),
--		IsRecommended		BIT,
--		ModPositionNo		INT,
--		ModPositionName		nvarchar(100),
--		FileCount			INT,
--		BoardNo				INT,
--		BoardName			nvarchar(100),
--		RegUserNo			INT,
--		RegUserName			NVARCHAR(100),
--		RegPositionNo		INT,
--		RegPositionName		nvarchar(100),
--		RegDepartNo			INT,
--		RegDepartName		NVARCHAR(100),
--		IsAlarm				BIT
--	)
	
--	DECLARE IsHead BIT, IsNotice BIT, IsRecommend BIT
--	DECLARE RecommendedDisplayCount INT
	
--	SELECT IsHead = IsHead, IsNotice = IsNotice, IsRecommend = IsRecommend, RecommendedDisplayCount = RecommendedDisplayCount
--	FROM Board_Boards
	
--	INSERT INTO TempTable
--		SELECT T.RowNum, BC.ContentNo, BC.Content, BC.ModUserNo,COALESCE( ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end),'') as ModUserName, BC.ModDepartNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName, BC.RegDate, BC.Title, BC.TitleEffect,
--			BC.GroupNo, BC.Depth, BC.OrderNo, BC.HeadNo, BC.IsNotice AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,
			
--			'' AS HeadName, 0 AS IsRecommended, BC.ModPositionNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

--			BC.RegUserNo, 
--		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
--		BC.RegPositionNo,
--		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
--		 BC.RegDepartNo,
--		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
--		,BC.IsAlarm
--		FROM SearchResult T
--		INNER JOIN Board_Contents BC ON BC.ContentNo = T.ContentNo
--		LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
--		WHERE T.RowNum BETWEEN StartRowNum AND EndRowNum 
		

--	SELECT * , (Select Count(*) From Board_ViewedLogs where Board_ViewedLogs.UserNo=UserNo AND BC.ContentNo=Board_ViewedLogs.ContentNo) As ReadCount, (SELECT BF.Name FROM Board_Files BF WHERE BF.ContentNo=BC.ContentNo AND (BF.Name ILIKE '%.gif' OR BF.Name ILIKE '%.png' OR BF.Name ILIKE '%.jpg' OR BF.Name ILIKE '%.jpeg' )) As AvataContent  FROM TempTable As BC ORDER BY RowNum ASC
--	SELECT TotalItemCount AS TotalContentCount, TotalPageCount AS TotalPageCount, CurrentPageIndex AS CurrentPageIndex
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.