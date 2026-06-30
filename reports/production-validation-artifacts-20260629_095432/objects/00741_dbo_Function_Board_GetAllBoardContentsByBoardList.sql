-- ─── FUNCTION: board_getallboardcontentsbyboardlist ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_getallboardcontentsbyboardlist(integer, character varying, integer, boolean, integer, integer, character varying, integer, timestamp without time zone, timestamp without time zone, integer, boolean, boolean);
CREATE OR REPLACE FUNCTION public.board_getallboardcontentsbyboardlist(
    userno integer,
    boardlist character varying,
    sortcolumn integer,
    isascending boolean,
    countperpage integer,
    currentpageindex integer,
    languagesign character varying,
    filtertype integer,
    fromdate timestamp without time zone,
    todate timestamp without time zone,
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
		SET strAlow = ' LEFT JOIN (SELECT * FROM public."Board_GetBoardAllow"(' || CONVERT(nvarchar(20), UserNo) + ',2)) AC ON BC.BoardNo=AC.BoardNo LEFT JOIN  (SELECT * FROM public."Board_GetBoardAllow"(' || CONVERT(nvarchar(20), UserNo) + ',4)) AD ON BC.BoardNo=AD.BoardNo '	
		SET strWriteAlow = '(AC.BoardNo IS NOT NULL OR (AD.BoardNo IS NOT NULL AND BC.RegUserNo = ' || CONVERT(nvarchar(10), UserNo) + ' )) AND '
	END

	/*
	 * 정렬 컬럼
	 */
	 
	IF (SortColumn <= 1) SET Query += 'RegDate '
	ELSE IF (SortColumn = 2) SET Query += 'LTRIM(Title) '
	ELSE IF (SortColumn = 3) SET Query += 'LTRIM(BB.Name) '
	ELSE IF (SortColumn = 4) SET Query += 'LTRIM(ModUserName) '
	ELSE IF (SortColumn = 5) SET Query += 'LTRIM(ModDepartName) '
	ELSE IF (SortColumn  = 6) SET Query += 'ViewedCount '
	ELSE IF (SortColumn = 7) SET Query += 'IsAlarm '


	/*
	 * 정렬 내림차순 여부
	 */
	 
	IF (IsAscending = TRUE) SET Query += 'ASC '
	ELSE SET Query += 'DESC '
	
	
	SET Query += ', OrderNo ASC'



	/*
	 * WHERE 조합 시작
	 */
		 
	SET Query +=
		') RowNum, BC.ContentNo, BC.Content ' +
		'FROM Board_Contents BC INNER JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo 
			' || strAlow || '
			WHERE  ' || strWriteAlow || ' BB.Enabled = TRUE AND  BC.Enabled = TRUE  
			 AND  ''' || BoardList || ''' ILIKE ( ''%,'' || CONVERT(nvarchar(200), BB.BoardNo) + '',%'') '
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

	IF COALESCE((select PermissionType from Authority_SitePermissions where UserNo = board_getallboardcontentsbyboardlist.userno), 0) <> 1 BEGIN

		SET Query +=  '		AND (RegDepartNo = ' || CONVERT(nvarchar(20), DepartNo) +' Or ContentNo NOT IN (SELECT distinct ContentNo FROM Board_Sharers WHERE DepartNo <> ' || CONVERT(nvarchar(20), DepartNo) +'))'		
	END	

	/*
	 * 게시글 검색 시작
	 */

	)

	INSERT INTO SearchResult
	EXEC SP_EXECUTESQL Query
		
		
		
	/*
	 * 페이징 계산
	 */





	SET TotalItemCount = (SELECT COUNT(*) FROM SearchResult)
	SET TotalPageCount = TotalItemCount / CountPerPage

	IF (TotalPageCount % CountPerPage > 0) SET TotalPageCount = TotalPageCount + 1
	IF (TotalPageCount = 0) SET TotalPageCount = 1
	--IF (CurrentPageIndex > TotalPageCount) SET CurrentPageIndex = TotalPageCount

	SET StartRowNum = ((CurrentPageIndex - 1) * CountPerPage) + 1
	SET EndRowNum = board_getallboardcontentsbyboardlist.currentpageindex * CountPerPage



	/*
	 *
	 */
	 

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
	FROM Board_Boards
	
	INSERT INTO TempTable
		RETURN QUERY
		SELECT BC.ContentNo, BC.Content, BC.ModUserNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end) as ModUserName, BC.ModDepartNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName, BC.RegDate, BC.Title, BC.TitleEffect,
			BC.GroupNo, BC.Depth, BC.OrderNo, BC.HeadNo, BC.IsNotice AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,
			
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
		WHERE T.RowNum BETWEEN StartRowNum AND EndRowNum 
		ORDER BY T.RowNum ASC

	RETURN QUERY
	SELECT * , (Select Count(*) From Board_ViewedLogs where Board_ViewedLogs.UserNo=board_getallboardcontentsbyboardlist.userno AND BC.ContentNo=Board_ViewedLogs.ContentNo) As ReadCount , (SELECT /* TOP 1 */ BF.Name FROM Board_Files BF WHERE BF.ContentNo=BC.ContentNo AND (BF.Name ILIKE '%.gif' OR BF.Name ILIKE '%.png' OR BF.Name ILIKE '%.jpg' OR BF.Name ILIKE '%.jpeg' )) As AvataContent  FROM TempTable As BC
	RETURN QUERY
	SELECT TotalItemCount AS TotalContentCount, TotalPageCount AS TotalPageCount, CurrentPageIndex AS CurrentPageIndex;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
