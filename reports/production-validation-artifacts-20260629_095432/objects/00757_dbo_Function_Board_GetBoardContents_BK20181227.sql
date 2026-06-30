-- ─── FUNCTION: board_getboardcontents_bk20181227 ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_getboardcontents_bk20181227(integer, integer, integer, boolean, integer, integer, character varying, integer, timestamp without time zone, timestamp without time zone, integer, boolean, boolean);
CREATE OR REPLACE FUNCTION public.board_getboardcontents_bk20181227(
    userno integer DEFAULT 70,
    boardno integer DEFAULT 53,
    sortcolumn integer DEFAULT 1,
    isascending boolean DEFAULT TRUE,
    countperpage integer DEFAULT 10,
    currentpageindex integer DEFAULT 1,
    languagesign character varying DEFAULT 'EN',
    filtertype integer DEFAULT 1,
    fromdate timestamp without time zone DEFAULT '2011-01-01 19:20:19.717',
    todate timestamp without time zone DEFAULT '2011-01-01 19:20:19.717',
    typeeff integer DEFAULT 0,
    isalarm boolean DEFAULT FALSE,
    isadmin boolean DEFAULT FALSE
) RETURNS TABLE(
    name text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
DECLARE
    query character varying;
    stralow character varying;
    strwritealow character varying;
    searchresult table (
		rownum		bigint,
		contentno	bigint,
		content nvarchar(max);
    totalitemcount integer;
    totalpagecount integer;
    startrownum integer;
    endrownum integer;
    recommendeddisplaycount integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


/*
	 * 쿼리 조합 시작
	 */


	SET Query = 'SELECT ROW_NUMBER() OVER (ORDER BY '



	SET strAlow = ''
	SET strWriteAlow = ''	
	if (IsAdmin = FALSE)
	BEGIN
		SET strAlow = ' LEFT JOIN (SELECT * FROM public."Board_GetBoardAllow"(' || CONVERT(nvarchar(20), UserNo) + ',2)) AC ON BC.BoardNo=AC.BoardNo 
			LEFT JOIN  (SELECT * FROM public."Board_GetBoardAllow"(' || CONVERT(nvarchar(20), UserNo) + ',4)) AD ON BC.BoardNo=AD.BoardNo 
			LEFT JOIN  (SELECT * FROM public."Board_GetBoardAllow"(' || CONVERT(nvarchar(20), UserNo) + ',1)) AE ON BC.BoardNo=AE.BoardNo '	
		SET strWriteAlow = '(AE.BoardNo IS NOT NULL OR AC.BoardNo IS NOT NULL OR (AD.BoardNo IS NOT NULL AND BC.RegUserNo = ' || CONVERT(nvarchar(10), UserNo) + ' )) AND '
	END

	/*
	 * 정렬 컬럼
	 */
	 
	IF (SortColumn <= 1) SET Query += '(CASE WHEN BC.Depth > 0 THEN BC.RootId ELSE BC.ContentNo END) '
	ELSE IF (SortColumn = 2) SET Query += 'LTRIM(Title) '
	ELSE IF (SortColumn = 3) SET Query += 'RegDate '
	ELSE IF (SortColumn = 4) SET Query += 'LTRIM(ModUserName) '
	ELSE IF (SortColumn = 5) SET Query += 'LTRIM(ModDepartName) '
	ELSE IF (SortColumn  = 6) SET Query += 'ViewedCount '
	ELSE IF (SortColumn = 7) SET Query += 'IsAlarm '


	/*
	 * 정렬 내림차순 여부
	 */
	 
	IF (IsAscending = TRUE) SET Query += 'ASC '
	-- Nghiem edit 2018-09-20 change DESC -> ASC
	ELSE SET Query += 'DESC '
	
	
	SET Query += ', BC.LevelRand + CAST(BC.ContentNo As Nvarchar(20)) ASC, OrderNo ASC'



	/*
	 * WHERE 조합 시작
	 */
		 
	SET Query +=
		') RowNum, ContentNo, Content ' +
		'FROM Board_Contents BC   INNER JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo 
			' || strAlow || '
			WHERE  ' || strWriteAlow || '  BC.BoardNo = BoardNo AND BC.Enabled = TRUE '
	
	SET Query +=  ' AND ( BC.RegDate >= ''' || CONVERT(nvarchar(20), FromDate) + ''' AND BC.RegDate <= ''' || CONVERT(nvarchar(20), ToDate) + '''  ' 

	SET Query +=  ' OR (SELECT COUNT(*) FROM Board_Replies BR WHERE BR.ContentNo=BC.ContentNo AND  BR.RegDate >= ''' || CONVERT(nvarchar(20), FromDate) + ''' AND BR.RegDate <= ''' || CONVERT(nvarchar(20), ToDate) + ''' ) > 0 ) ' 

	IF (TypeEff > 0)
	BEGIN
		SET Query += ' AND BC.TitleEffect <> 2 '
	END
	IF (IsAlarm > 0)
	BEGIN
		SET Query += ' AND BC.IsAlarm = TRUE '
	END
	IF (FilterType <> 100)
	BEGIN
		SET Query += 'AND BC.RegUserNo <> ' || CONVERT(nvarchar(10), UserNo) + ' AND (Select Count(*) From Board_ViewedLogs where Board_ViewedLogs.UserNo=' || CONVERT(nvarchar(10), UserNo) + ' AND BC.ContentNo=Board_ViewedLogs.ContentNo) <= 0  '
	END


	if (IsAdmin = FALSE)  BEGIN

		--SET Query +=' AND BC.ContentNo IN (SELECT DISTINCT BS1.ContentNo FROM Board_Sharers BS1 inner JOIN public."Organization_GetDepartmentsByUser" (' || CONVERT(nvarchar(10), UserNo) +  ') DP ON DP.DepartNo= BS1.DepartNo)'

	--SELECT * FROM Board_Sharers BS1 INNER JOIN Organization_BelongToDepartment DP ON DP.DepartNo= BS1.DepartNo WHERE UserNo=222
	--((SELECT COUNT(*) FROM Board_Sharers BS2 WHERE BS2.CONTENTNO = 16) <=0 )
		SET Query +=  '  AND ((AE.BoardNo IS NOT NULL  AND BB.SpecType > 1) OR ( BC.RegUserNo = ' || CONVERT(nvarchar(10), UserNo) + ') OR (BC.ContentNo IN (SELECT DISTINCT BS1.ContentNo FROM Board_Sharers BS1 inner JOIN public."Organization_GetDepartmentsByUser" (' || CONVERT(nvarchar(10), UserNo) +  ') DP ON DP.DepartNo= BS1.DepartNo)) OR (BC.ContentNo IN ( SELECT BSS1.ContentNo FROM Board_Sharers BSS1
where BSS1.contentno=BC.ContentNo and BSS1.userno=' || CONVERT(nvarchar(10),UserNo ) +  ')) OR ((SELECT COUNT(*) FROM Board_Sharers BS2 WHERE BS2.CONTENTNO = BC.ContentNO) <=0 ) )'
		--DECLARE DepartNo INT = (SELECT /* TOP 1 */ DepartNo FROM Organization_BelongToDepartment WHERE UserNo = UserNo)
		--SET Query +=  ' AND ( BC.RegUserNo <> ' || CONVERT(nvarchar(10), UserNo) +' Or ContentNo NOT IN (SELECT distinct ContentNo FROM Board_Sharers WHERE DepartNo <> ' || CONVERT(nvarchar(20), DepartNo) +'))'		
	--END	
	--IF COALESCE((select PermissionType from Authority_SitePermissions where UserNo = UserNo), 0) <> 1 BEGIN
	--	DECLARE DepartNo INT = (SELECT /* TOP 1 */ DepartNo FROM Organization_BelongToDepartment WHERE UserNo = UserNo)
	--	SET Query +=  '		AND (RegDepartNo = ' || CONVERT(nvarchar(20), DepartNo) +' Or ContentNo NOT IN (SELECT distinct ContentNo FROM Board_Sharers WHERE DepartNo <> ' || CONVERT(nvarchar(20), DepartNo) +'))'		
	END	

	/*
	 * 게시글 검색 시작
	 */
	 
	 RAISE NOTICE '%', Query

	)

	INSERT INTO SearchResult
	EXEC SP_EXECUTESQL Query,
		'BoardNo AS INT',
		BoardNo
		
		
		
	/*
	 * 페이징 계산
	 */





	SET TotalItemCount = (SELECT COUNT(*) FROM SearchResult)
	SET TotalPageCount = TotalItemCount / CountPerPage

	IF (TotalItemCount % CountPerPage > 0) SET TotalPageCount = TotalPageCount + 1
	IF (TotalPageCount = 0) SET TotalPageCount = 1
	--IF (CurrentPageIndex > TotalPageCount) SET CurrentPageIndex = TotalPageCount

	SET StartRowNum = ((CurrentPageIndex - 1) * CountPerPage) + 1
	SET EndRowNum = board_getboardcontents_bk20181227.currentpageindex * CountPerPage



	/*
	 *
	 */
	 

		RN INT,
		ContentNo			BIGINT,
		Content				text,
		ModUserNo			INT,
		ModUserName			NVARCHAR(100),
		ModDepartNo			INT,
		ModDepartName		NVARCHAR(100),
		RegDate				DATETIME,
		Title				NVARCHAR(200),
		TitleEffect			INT,
		GroupNo				BIGINT,
		Depth				INT,
		OrderNo				INT,
		HeadNo				INT,
		IsNotice			BIT,
		IsFile				BIT,
		ReplyCount			INT,
		RecommendedCount	INT,
		ViewedCount			INT,
		
		HeadName			NVARCHAR(100),
		IsRecommended		BIT,
		ModPositionNo		INT,
		ModPositionName		nvarchar(100),
		FileCount			INT,
		BoardNo				INT,
		BoardName			nvarchar(100),
		RegUserNo			INT,
		RegUserName			NVARCHAR(100),
		RegPositionNo		INT,
		RegPositionName		nvarchar(100),
		RegDepartNo			INT,
		RegDepartName		NVARCHAR(100),
		IsAlarm				BIT
	)
	


	SELECT IsHead = IsHead, IsNotice = IsNotice, IsRecommend = IsRecommend, RecommendedDisplayCount = RecommendedDisplayCount
	FROM Board_Boards WHERE BoardNo = board_getboardcontents_bk20181227.boardno
	
	IF (IsHead = TRUE) BEGIN
	
		IF (IsNotice = TRUE) BEGIN
		
			INSERT INTO TempTable
			RETURN QUERY
			SELECT 0, BC.ContentNo, BC.Content, BC.ModUserNo,COALESCE(( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end),'') as ModUserName, BC.ModDepartNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName, 
			 BC.RegDate, BC.Title, 0 AS TitleEffect,
				BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 1 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,
				
				COALESCE(BH.Name, '') AS HeadName, 0 AS IsRecommended, BC.ModPositionNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

				BC.RegUserNo, 
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
		BC.RegPositionNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
		 BC.RegDepartNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
		,BC.IsAlarm

			FROM Board_Contents BC
			LEFT JOIN (SELECT HeadNo, Name FROM Board_Heads WHERE BoardNo = board_getboardcontents_bk20181227.boardno) BH ON BH.HeadNo = BC.HeadNo
			LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
			WHERE BC.BoardNo = board_getboardcontents_bk20181227.boardno AND BC.Enabled = TRUE AND BC.IsNotice = TRUE
		
		END
		
		IF (IsRecommend = TRUE AND RecommendedDisplayCount > 0) BEGIN

			INSERT INTO TempTable
			RETURN QUERY
			SELECT TOP (RecommendedDisplayCount) 0, BC.ContentNo, BC.Content, BC.ModUserNo, COALESCE(( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end),'') as ModUserName, BC.ModDepartNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName, BC.RegDate, BC.Title, 0 AS TitleEffect,
				BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 0 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,
				
				COALESCE(BH.Name, '') AS HeadName, 1 AS IsRecommended , BC.ModPositionNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

				BC.RegUserNo, 
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
		BC.RegPositionNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
		 BC.RegDepartNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
		,BC.IsAlarm
			FROM Board_Contents BC 
			LEFT JOIN (SELECT HeadNo, Name FROM Board_Heads WHERE BoardNo = board_getboardcontents_bk20181227.boardno) BH ON BH.HeadNo = BC.HeadNo
			LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
			WHERE BC.BoardNo = board_getboardcontents_bk20181227.boardno AND BC.Enabled = TRUE AND BC.RecommendedCount > 0 and BC.IsNotice = FALSE
			ORDER BY RecommendedCount DESC
		
		END
	
		INSERT INTO TempTable
		RETURN QUERY
		SELECT T.RowNum ,BC.ContentNo, BC.Content, BC.ModUserNo, COALESCE(( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end),'') as ModUserName, BC.ModDepartNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName, BC.RegDate, BC.Title, BC.TitleEffect,
			BC.GroupNo, BC.Depth, BC.OrderNo, BC.HeadNo, 0 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,
			
			COALESCE(BH.Name, '') AS HeadName, 0 AS IsRecommended, BC.ModPositionNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

			BC.RegUserNo, 
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
		BC.RegPositionNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
		 BC.RegDepartNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
		,BC.IsAlarm
		FROM SearchResult T
		INNER JOIN Board_Contents BC ON BC.ContentNo = T.ContentNo
		LEFT JOIN (SELECT HeadNo, Name FROM Board_Heads WHERE BoardNo = board_getboardcontents_bk20181227.boardno) BH ON BH.HeadNo = BC.HeadNo
		LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
			WHERE T.RowNum BETWEEN StartRowNum AND EndRowNum and BC.IsNotice = FALSE

	END
	
	ELSE BEGIN
	
		IF (IsNotice = TRUE) BEGIN
		
			INSERT INTO TempTable
			RETURN QUERY
			SELECT 0,BC.ContentNo, BC.Content, BC.ModUserNo, COALESCE(( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end),'') as ModUserName, BC.ModDepartNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName, BC.RegDate, BC.Title, 0 AS TitleEffect,
				BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 1 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,
				
				'' AS HeadName, 0 AS IsRecommended, BC.ModPositionNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

				BC.RegUserNo, 
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
		BC.RegPositionNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
		 BC.RegDepartNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
			,BC.IsAlarm
			FROM Board_Contents BC
			LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
			WHERE BC.BoardNo = board_getboardcontents_bk20181227.boardno AND BC.IsNotice = TRUE AND BC.Enabled = TRUE
		
		END
		
		IF (IsRecommend = TRUE AND RecommendedDisplayCount > 0) BEGIN

			INSERT INTO TempTable
			RETURN QUERY
			SELECT TOP (RecommendedDisplayCount) 0,BC.ContentNo, BC.Content, BC.ModUserNo, COALESCE(( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end),'') as ModUserName, BC.ModDepartNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName, BC.RegDate, BC.Title, 0 AS TitleEffect,
				BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 0 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,
				
				'' AS HeadName, 1 AS IsRecommended, BC.ModPositionNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

				BC.RegUserNo, 
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
		BC.RegPositionNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
		 BC.RegDepartNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
			,BC.IsAlarm
			FROM Board_Contents BC
			LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
			WHERE BC.BoardNo = board_getboardcontents_bk20181227.boardno AND BC.RecommendedCount > 0 AND BC.Enabled = TRUE and BC.IsNotice = FALSE
			ORDER BY RecommendedCount DESC
		
		END
		
		INSERT INTO TempTable
		RETURN QUERY
		SELECT T.RowNum ,BC.ContentNo, BC.Content, BC.ModUserNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end) as ModUserName, BC.ModDepartNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName, BC.RegDate, BC.Title, BC.TitleEffect,
			BC.GroupNo, BC.Depth, BC.OrderNo, BC.HeadNo, 0 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,
			
			'' AS HeadName, 0 AS IsRecommended, BC.ModPositionNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

			BC.RegUserNo, 
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
		BC.RegPositionNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
		 BC.RegDepartNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
		,BC.IsAlarm
		FROM SearchResult T
		INNER JOIN Board_Contents BC ON BC.ContentNo = T.ContentNo
		LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
			WHERE T.RowNum BETWEEN StartRowNum AND EndRowNum and BC.IsNotice = FALSE
		

	END

	RETURN QUERY
	SELECT * , (Select Count(*) From Board_ViewedLogs where Board_ViewedLogs.UserNo=board_getboardcontents_bk20181227.userno AND BC.ContentNo=Board_ViewedLogs.ContentNo) As ReadCount , (SELECT /* TOP 1 */ BF.Name FROM Board_Files BF WHERE BF.ContentNo=BC.ContentNo AND (BF.Name ILIKE '%.gif' OR BF.Name ILIKE '%.png' OR BF.Name ILIKE '%.jpg' OR BF.Name ILIKE '%.jpeg' )) As AvataContent  FROM TempTable As BC ORDER BY RN ASC
	RETURN QUERY
	SELECT TotalItemCount AS TotalContentCount, TotalPageCount AS TotalPageCount, CurrentPageIndex AS CurrentPageIndex;


	--/*
	-- * 쿼리 조합 시작
	-- */

	--DECLARE Query NVARCHAR(2000)
	--SET Query = 'SELECT ROW_NUMBER() OVER (ORDER BY '

	--DECLARE strAlow NVARCHAR(2000)
	--DECLARE strWriteAlow NVARCHAR(2000)
	--SET strAlow = ''
	--SET strWriteAlow = ''	
	--if (IsAdmin = FALSE)
	--BEGIN
	--	SET strAlow = ' LEFT JOIN (SELECT * FROM public."Board_GetBoardAllow"(' || CONVERT(nvarchar(20), UserNo) + ',2)) AC ON BC.BoardNo=AC.BoardNo LEFT JOIN  (SELECT * FROM public."Board_GetBoardAllow"(' || CONVERT(nvarchar(20), UserNo) + ',4)) AD ON BC.BoardNo=AD.BoardNo '	
	--	SET strWriteAlow = '(AC.BoardNo IS NOT NULL OR (AD.BoardNo IS NOT NULL AND BC.RegUserNo = ' || CONVERT(nvarchar(10), UserNo) + ' )) AND '
	--END

	--/*
	-- * 정렬 컬럼
	-- */
	 
	--IF (SortColumn <= 1) SET Query += 'RegDate '
	--ELSE IF (SortColumn = 2) SET Query += 'LTRIM(Title) '
	--ELSE IF (SortColumn = 3) SET Query += 'RegDate '
	--ELSE IF (SortColumn = 4) SET Query += 'LTRIM(ModUserName) '
	--ELSE IF (SortColumn = 5) SET Query += 'LTRIM(ModDepartName) '
	--ELSE IF (SortColumn  = 6) SET Query += 'ViewedCount '
	--ELSE IF (SortColumn = 7) SET Query += 'IsAlarm '


	--/*
	-- * 정렬 내림차순 여부
	-- */
	 
	--IF (IsAscending = TRUE) SET Query += 'ASC '
	--ELSE SET Query += 'DESC '
	
	
	--SET Query += ', OrderNo ASC'



	--/*
	-- * WHERE 조합 시작
	-- */
		 
	--SET Query +=
	--	') RowNum, ContentNo, Content ' +
	--	'FROM Board_Contents BC 
	--		' || strAlow || '
	--		WHERE  ' || strWriteAlow || '  BC.BoardNo = BoardNo AND Enabled = TRUE '
	
	--SET Query +=  ' AND ( BC.RegDate >= ''' || CONVERT(nvarchar(20), FromDate) + ''' AND BC.RegDate <= ''' || CONVERT(nvarchar(20), ToDate) + '''  ' 

	--SET Query +=  ' OR (SELECT COUNT(*) FROM Board_Replies BR WHERE BR.ContentNo=BC.ContentNo AND  BR.RegDate >= ''' || CONVERT(nvarchar(20), FromDate) + ''' AND BR.RegDate <= ''' || CONVERT(nvarchar(20), ToDate) + ''' ) > 0 ) ' 

	--IF (TypeEff > 0)
	--BEGIN
	--	SET Query += ' AND BC.TitleEffect <> 2 '
	--END
	--IF (IsAlarm > 0)
	--BEGIN
	--	SET Query += ' AND BC.IsAlarm = TRUE '
	--END
	--IF (FilterType <> 100)
	--BEGIN
	--	SET Query += 'AND BC.RegUserNo <> ' || CONVERT(nvarchar(10), UserNo) + ' AND (Select Count(*) From Board_ViewedLogs where Board_ViewedLogs.UserNo=' || CONVERT(nvarchar(10), UserNo) + ' AND BC.ContentNo=Board_ViewedLogs.ContentNo) <= 0  '
	--END

	--IF COALESCE((select PermissionType from Authority_SitePermissions where UserNo = UserNo), 0) <> 1 BEGIN
	--	DECLARE DepartNo INT = (SELECT /* TOP 1 */ DepartNo FROM Organization_BelongToDepartment WHERE UserNo = UserNo)
	--	SET Query +=  '		AND (RegDepartNo = ' || CONVERT(nvarchar(20), DepartNo) +' Or ContentNo NOT IN (SELECT distinct ContentNo FROM Board_Sharers WHERE DepartNo <> ' || CONVERT(nvarchar(20), DepartNo) +'))'		
	--END	

	--/*
	-- * 게시글 검색 시작
	-- */
	 
	--DECLARE SearchResult TABLE (
	--	RowNum		BIGINT,
	--	ContentNo	BIGINT,
	--	Content text
	--)

	--INSERT INTO SearchResult
	--EXEC SP_EXECUTESQL Query,
	--	'BoardNo AS INT',
	--	BoardNo
		
		
		
	--/*
	-- * 페이징 계산
	-- */

	--DECLARE TotalItemCount INT
	--DECLARE TotalPageCount INT
	--DECLARE StartRowNum INT
	--DECLARE EndRowNum INT

	--SET TotalItemCount = (SELECT COUNT(*) FROM SearchResult)
	--SET TotalPageCount = TotalItemCount / CountPerPage

	--IF (TotalPageCount % CountPerPage > 0) SET TotalPageCount = TotalPageCount + 1
	--IF (TotalPageCount = 0) SET TotalPageCount = 1
	----IF (CurrentPageIndex > TotalPageCount) SET CurrentPageIndex = TotalPageCount

	--SET StartRowNum = ((CurrentPageIndex - 1) * CountPerPage) + 1
	--SET EndRowNum = CurrentPageIndex * CountPerPage



	--/*
	-- *
	-- */
	 
	--DECLARE TempTable TABLE (
	--	ContentNo			BIGINT,
	--	Content				text,
	--	ModUserNo			INT,
	--	ModUserName			NVARCHAR(100),
	--	ModDepartNo			INT,
	--	ModDepartName		NVARCHAR(100),
	--	RegDate				DATETIME,
	--	Title				NVARCHAR(200),
	--	TitleEffect			INT,
	--	GroupNo				BIGINT,
	--	Depth				INT,
	--	OrderNo				INT,
	--	HeadNo				INT,
	--	IsNotice			BIT,
	--	IsFile				BIT,
	--	ReplyCount			INT,
	--	RecommendedCount	INT,
	--	ViewedCount			INT,
		
	--	HeadName			NVARCHAR(100),
	--	IsRecommended		BIT,
	--	ModPositionNo		INT,
	--	ModPositionName		nvarchar(100),
	--	FileCount			INT,
	--	BoardNo				INT,
	--	BoardName			nvarchar(100),
	--	RegUserNo			INT,
	--	RegUserName			NVARCHAR(100),
	--	RegPositionNo		INT,
	--	RegPositionName		nvarchar(100),
	--	RegDepartNo			INT,
	--	RegDepartName		NVARCHAR(100),
	--	IsAlarm				BIT
	--)
	
	--DECLARE IsHead BIT, IsNotice BIT, IsRecommend BIT
	--DECLARE RecommendedDisplayCount INT
	
	--SELECT IsHead = IsHead, IsNotice = IsNotice, IsRecommend = IsRecommend, RecommendedDisplayCount = RecommendedDisplayCount
	--FROM Board_Boards WHERE BoardNo = BoardNo
	
	--IF (IsHead = TRUE) BEGIN
	
	--	IF (IsNotice = TRUE) BEGIN
		
	--		INSERT INTO TempTable
	--		SELECT BC.ContentNo, BC.Content, BC.ModUserNo,( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end) as ModUserName, BC.ModDepartNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName, 
	--		 BC.RegDate, BC.Title, 0 AS TitleEffect,
	--			BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 1 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,
				
	--			COALESCE(BH.Name, '') AS HeadName, 0 AS IsRecommended, BC.ModPositionNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

	--			BC.RegUserNo, 
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
	--	BC.RegPositionNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
	--	 BC.RegDepartNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
	--	,BC.IsAlarm

	--		FROM Board_Contents BC
	--		LEFT JOIN (SELECT HeadNo, Name FROM Board_Heads WHERE BoardNo = BoardNo) BH ON BH.HeadNo = BC.HeadNo
	--		LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
	--		WHERE BC.BoardNo = BoardNo AND BC.Enabled = TRUE AND BC.IsNotice = TRUE
		
	--	END
		
	--	IF (IsRecommend = TRUE AND RecommendedDisplayCount > 0) BEGIN

	--		INSERT INTO TempTable
	--		SELECT TOP (RecommendedDisplayCount) BC.ContentNo, BC.Content, BC.ModUserNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end) as ModUserName, BC.ModDepartNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName, BC.RegDate, BC.Title, 0 AS TitleEffect,
	--			BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 0 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,
				
	--			COALESCE(BH.Name, '') AS HeadName, 1 AS IsRecommended , BC.ModPositionNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

	--			BC.RegUserNo, 
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
	--	BC.RegPositionNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
	--	 BC.RegDepartNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
	--	,BC.IsAlarm
	--		FROM Board_Contents BC 
	--		LEFT JOIN (SELECT HeadNo, Name FROM Board_Heads WHERE BoardNo = BoardNo) BH ON BH.HeadNo = BC.HeadNo
	--		LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
	--		WHERE BC.BoardNo = BoardNo AND BC.Enabled = TRUE AND BC.RecommendedCount > 0 and BC.IsNotice = FALSE
	--		ORDER BY RecommendedCount DESC
		
	--	END
	
	--	INSERT INTO TempTable
	--	SELECT BC.ContentNo, BC.Content, BC.ModUserNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end) as ModUserName, BC.ModDepartNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName, BC.RegDate, BC.Title, BC.TitleEffect,
	--		BC.GroupNo, BC.Depth, BC.OrderNo, BC.HeadNo, 0 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,
			
	--		COALESCE(BH.Name, '') AS HeadName, 0 AS IsRecommended, BC.ModPositionNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

	--		BC.RegUserNo, 
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
	--	BC.RegPositionNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
	--	 BC.RegDepartNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
	--	,BC.IsAlarm
	--	FROM SearchResult T
	--	INNER JOIN Board_Contents BC ON BC.ContentNo = T.ContentNo
	--	LEFT JOIN (SELECT HeadNo, Name FROM Board_Heads WHERE BoardNo = BoardNo) BH ON BH.HeadNo = BC.HeadNo
	--	LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
	--		WHERE T.RowNum BETWEEN StartRowNum AND EndRowNum and BC.IsNotice = FALSE
	--	ORDER BY T.RowNum ASC

	--END
	
	--ELSE BEGIN
	
	--	IF (IsNotice = TRUE) BEGIN
		
	--		INSERT INTO TempTable
	--		SELECT BC.ContentNo, BC.Content, BC.ModUserNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end) as ModUserName, BC.ModDepartNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName, BC.RegDate, BC.Title, 0 AS TitleEffect,
	--			BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 1 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,
				
	--			'' AS HeadName, 0 AS IsRecommended, BC.ModPositionNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

	--			BC.RegUserNo, 
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
	--	BC.RegPositionNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
	--	 BC.RegDepartNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
	--		,BC.IsAlarm
	--		FROM Board_Contents BC
	--		LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
	--		WHERE BC.BoardNo = BoardNo AND BC.IsNotice = TRUE AND BC.Enabled = TRUE
		
	--	END
		
	--	IF (IsRecommend = TRUE AND RecommendedDisplayCount > 0) BEGIN

	--		INSERT INTO TempTable
	--		SELECT TOP (RecommendedDisplayCount) BC.ContentNo, BC.Content, BC.ModUserNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end) as ModUserName, BC.ModDepartNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName, BC.RegDate, BC.Title, 0 AS TitleEffect,
	--			BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 0 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,
				
	--			'' AS HeadName, 1 AS IsRecommended, BC.ModPositionNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

	--			BC.RegUserNo, 
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
	--	BC.RegPositionNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
	--	 BC.RegDepartNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
	--		,BC.IsAlarm
	--		FROM Board_Contents BC
	--		LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
	--		WHERE BC.BoardNo = BoardNo AND BC.RecommendedCount > 0 AND BC.Enabled = TRUE and BC.IsNotice = FALSE
	--		ORDER BY RecommendedCount DESC
		
	--	END
		
	--	INSERT INTO TempTable
	--	SELECT BC.ContentNo, BC.Content, BC.ModUserNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end) as ModUserName, BC.ModDepartNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName, BC.RegDate, BC.Title, BC.TitleEffect,
	--		BC.GroupNo, BC.Depth, BC.OrderNo, BC.HeadNo, 0 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,
			
	--		'' AS HeadName, 0 AS IsRecommended, BC.ModPositionNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

	--		BC.RegUserNo, 
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
	--	BC.RegPositionNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
	--	 BC.RegDepartNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
	--	,BC.IsAlarm
	--	FROM SearchResult T
	--	INNER JOIN Board_Contents BC ON BC.ContentNo = T.ContentNo
	--	LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
	--		WHERE T.RowNum BETWEEN StartRowNum AND EndRowNum and BC.IsNotice = FALSE
	--	ORDER BY T.RowNum ASC

	--END

	--SELECT * , (Select Count(*) From Board_ViewedLogs where Board_ViewedLogs.UserNo=UserNo AND BC.ContentNo=Board_ViewedLogs.ContentNo) As ReadCount , (SELECT /* TOP 1 */ BF.Name FROM Board_Files BF WHERE BF.ContentNo=BC.ContentNo AND (BF.Name ILIKE '%.gif' OR BF.Name ILIKE '%.png' OR BF.Name ILIKE '%.jpg' OR BF.Name ILIKE '%.jpeg' )) As AvataContent  FROM TempTable As BC
	--SELECT TotalItemCount AS TotalContentCount, TotalPageCount AS TotalPageCount, CurrentPageIndex AS CurrentPageIndex
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
