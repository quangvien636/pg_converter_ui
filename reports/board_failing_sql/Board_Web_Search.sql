-- ─── PROCEDURE→FUNCTION: board_web_search ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: Dynamic SQL detected. Manual rewrite required for PostgreSQL.
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.board_web_search(integer, character varying, integer, integer, boolean, integer, integer, character varying, integer, timestamp without time zone, timestamp without time zone, integer, integer, boolean, boolean);
CREATE OR REPLACE FUNCTION public.board_web_search(
    IN userno integer,
    IN searchtext character varying,
    IN searchtype integer,
    IN sortcolumn integer,
    IN isascending boolean,
    IN countperpage integer,
    IN currentpageindex integer,
    IN languagesign character varying,
    IN filtertype integer,
    IN fromdate timestamp without time zone,
    IN todate timestamp without time zone,
    IN viewmode integer DEFAULT 2,
    IN typeeff integer DEFAULT 0,
    IN isalarm boolean DEFAULT FALSE,
    IN isadmin boolean DEFAULT FALSE
) RETURNS SETOF record
AS $function$
DECLARE
    query character varying;
    stralow character varying;
    strwritealow character varying;
    totalitemcount integer;
    totalpagecount integer;
    startrownum integer;
    endrownum integer;
    ishead boolean;
    isnotice boolean;
    isrecommend boolean;
    recommendeddisplaycount integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	/*
	 * 쿼리 조합 시작
	 */;


	Query := 'SELECT ROW_NUMBER() OVER (ORDER BY ';
	strAlow := '';
	strWriteAlow := '';
	IF IsAdmin = FALSE THEN
		strAlow := ' LEFT JOIN (SELECT * FROM public."Board_GetBoardAllow"(' || CONVERT(nvarchar(20), UserNo) + ',2)) AC ON BC.BoardNo=AC.BoardNo LEFT JOIN  (SELECT * FROM public."Board_GetBoardAllow"(' || CONVERT(nvarchar(20), UserNo) + ',4)) AD ON BC.BoardNo=AD.BoardNo ';
		strWriteAlow := '(AC.BoardNo IS NOT NULL OR (AD.BoardNo IS NOT NULL AND BC.RegUserNo = ' || CONVERT(nvarchar(10), UserNo) + ' )) AND ';
	END IF;

	/*
	 * 정렬 컬럼
	 */
	 
	IF SortColumn <= 1 THEN
	    query := COALESCE(query, '') || COALESCE(('BC.RegDate '), '');
	ELSIF SortColumn = 2 THEN
	    query := COALESCE(query, '') || COALESCE(('LTRIM(BC.Title) '), '');
	ELSIF SortColumn = 3 THEN
	    query := COALESCE(query, '') || COALESCE(('LTRIM(BB.Name) '), '');
	ELSIF SortColumn = 4 THEN
	    query := COALESCE(query, '') || COALESCE(('LTRIM(BC.ModUserName) '), '');
	ELSIF SortColumn = 5 THEN
	    query := COALESCE(query, '') || COALESCE(('LTRIM(BC.ModDepartName) '), '');
	ELSIF SortColumn  = 6 THEN
	    query := COALESCE(query, '') || COALESCE(('BC.ViewedCount '), '');
	ELSIF SortColumn = 7 THEN
	    query := COALESCE(query, '') || COALESCE(('IsAlarm '), '');
	END IF;



	/*
	 * 정렬 내림차순 여부
	 */
	 
	IF IsAscending = TRUE THEN
	    query := COALESCE(query, '') || COALESCE(('ASC '), '');
	ELSE
	    query := COALESCE(query, '') || COALESCE(('DESC '), '');
	END IF;
	
	
	query := COALESCE(query, '') || COALESCE((', BC.OrderNo ASC'), '');



	/*
	 * WHERE 조합 시작
	 */
	IF SearchType = 0 THEN
	query := COALESCE(query, '') || COALESCE((') RowNum, BC.ContentNo, BC.Content ' || 'FROM Board_Contents BC  INNER JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
' || strAlow || '
WHERE  ' || strWriteAlow || '  BB.Enabled = TRUE AND  (BC.Title ILIKE ''%' || SearchText || '%'' OR BC.ModUserName ILIKE ''%' || SearchText || '%'' OR  (SELECT COUNT(*) FROM Board_Replies BR WHERE BR.ContentNo=BC.ContentNo AND  BR.ModUserName ILIKE ''%' || SearchText || '%'' ) > 0 ) AND  BC.Enabled = TRUE '), '');
		RAISE NOTICE '%', Query;

	IF SearchType = 1 THEN
	query := COALESCE(query, '') || COALESCE((') RowNum, BC.ContentNo, BC.Content ' || 'FROM Board_Contents BC  INNER JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
' || strAlow || '
WHERE  ' || strWriteAlow || '  BB.Enabled = TRUE AND (BC.Title ILIKE ''%' || SearchText || '%'') AND  BC.Enabled = TRUE '), '');
		RAISE NOTICE '%', Query;

	IF SearchType = 2 THEN
	query := COALESCE(query, '') || COALESCE((') RowNum, BC.ContentNo, BC.Content ' || 'FROM Board_Contents BC  INNER JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
' || strAlow || '
WHERE  ' || strWriteAlow || '  BB.Enabled = TRUE AND (BC.ModUserName ILIKE ''%' || SearchText || '%'' OR  (SELECT COUNT(*) FROM Board_Replies BR WHERE BR.ContentNo=BC.ContentNo AND  BR.ModUserName ILIKE ''%' || SearchText || '%'' ) > 0) AND  BC.Enabled = TRUE '), '');
		RAISE NOTICE '%', Query;

	IF SearchType = 3 THEN
	query := COALESCE(query, '') || COALESCE((') RowNum, BC.ContentNo, BC.Content ' || 'FROM Board_Contents BC  INNER JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
' || strAlow || '
WHERE  ' || strWriteAlow || '  BB.Enabled = TRUE AND (BC.ModDepartName ILIKE ''%' || SearchText || '%'') AND  BC.Enabled = TRUE '), '');
		RAISE NOTICE '%', Query;

	IF SearchType = 4 THEN
	query := COALESCE(query, '') || COALESCE((') RowNum, BC.ContentNo, BC.Content ' || 'FROM Board_Contents BC  INNER JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
' || strAlow || '
WHERE  ' || strWriteAlow || '  BB.Enabled = TRUE AND (BC.RegDate ILIKE ''%' || SearchText || '%'') AND  BC.Enabled = TRUE '), '');
		RAISE NOTICE '%', Query;
	/*
	 * 게시글 검색 시작
	 */;

	query := COALESCE(query, '') || COALESCE((' AND ( BC.ViewMode=' || CONVERT(nvarchar(10), ViewMode) || ' OR ' || CONVERT(nvarchar(10), ViewMode) || '< 0) '), '');
	
	query := COALESCE(query, '') || COALESCE((' AND ( BC.RegDate >= ''' || CONVERT(nvarchar(20), FromDate) || ''' AND BC.RegDate <= ''' || CONVERT(nvarchar(20), ToDate) || '''  '), '');

	query := COALESCE(query, '') || COALESCE((' OR (SELECT COUNT(*) FROM Board_Replies BR WHERE BR.ContentNo=BC.ContentNo AND  BR.RegDate >= ''' || CONVERT(nvarchar(20), FromDate) || ''' AND BR.RegDate <= ''' || CONVERT(nvarchar(20), ToDate) || ''' ) > 0 ) '), '');

	IF TypeEff > 0 THEN
		query := COALESCE(query, '') || COALESCE((' AND BC.TitleEffect <> 2 '), '');
	END IF;
	IF IsAlarm > 0 THEN
		query := COALESCE(query, '') || COALESCE((' AND BC.IsAlarm = TRUE '), '');
	END IF;
	IF FilterType <> 100 THEN
		query := COALESCE(query, '') || COALESCE(('AND BC.RegUserNo <> ' || CONVERT(nvarchar(10), UserNo) || ' AND (Select Count(*) From Board_ViewedLogs where Board_ViewedLogs.UserNo=' || CONVERT(nvarchar(10), UserNo) || ' AND BC.ContentNo=Board_ViewedLogs.ContentNo) <= 0  '), '');
	END IF;
	 

	CREATE TEMP TABLE SearchResult (
		RowNum		BIGINT,
		
		ContentNo	BIGINT,
		Content		text
	) ON COMMIT DROP;
	INSERT INTO SearchResult;
	PERFORM query();
	/*
	 * 페이징 계산
	 */;






	TotalItemCount := (SELECT COUNT(*) FROM SearchResult);
	TotalPageCount := TotalItemCount / CountPerPage;
	IF TotalPageCount % CountPerPage > 0 THEN
	    TotalPageCount := TotalPageCount + 1;
	END IF;
	IF TotalPageCount = 0 THEN
	    TotalPageCount := 1;
	END IF;
	--IF (CurrentPageIndex > TotalPageCount) SET CurrentPageIndex = TotalPageCount;

	StartRowNum := ((CurrentPageIndex - 1) * CountPerPage) + 1;
	EndRowNum := board_web_search.currentpageindex * CountPerPage;
	/*
	 *
	 */
	 
	CREATE TEMP TABLE TempTable (
		ContentNo			BIGINT,
		Content				text,
		ModUserNo			INT,
		ModUserName			varchar(100),
		ModDepartNo			INT,
		ModDepartName		varchar(100),
		RegDate				timestamp,
		Title				varchar(200),
		TitleEffect			INT,
		GroupNo				BIGINT,
		Depth				INT,
		OrderNo				INT,
		HeadNo				INT,
		IsNotice			boolean,
		IsFile				boolean,
		ReplyCount			INT,
		RecommendedCount	INT,
		ViewedCount			INT,
		
		HeadName			varchar(100),
		IsRecommended		boolean,

		ModPositionNo		INT,
		ModPositionName		varchar(100),
		FileCount			INT,
		BoardNo				INT,
		BoardName			varchar(100),
		RegUserNo			INT,
		RegUserName			varchar(100),
		RegPositionNo		INT,
		RegPositionName		varchar(100),
		RegDepartNo			INT,
		RegDepartName		varchar(100),
		IsAlarm				boolean

	) ON COMMIT DROP;
	


	
	SELECT IsHead, IsNotice, IsRecommend, RecommendedDisplayCount INTO ishead, isnotice, isrecommend, recommendeddisplaycount FROM Board_Boards;

	
	IF IsHead = TRUE THEN
	
		IF IsNotice = TRUE THEN
		
			INSERT INTO TempTable
			SELECT BC.ContentNo, BC.Content, BC.ModUserNo, BC.ModUserName, BC.ModDepartNo, BC.ModDepartName, BC.RegDate, BC.Title, 0 AS TitleEffect,
				BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 1 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,
				
				COALESCE(BH.Name, '') AS HeadName, 0 AS IsRecommended,

				BC.ModPositionNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

				BC.RegUserNo, 
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
		BC.RegPositionNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
		 BC.RegDepartNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
		,BC.IsAlarm

			FROM Board_Contents BC
			LEFT JOIN (SELECT HeadNo, Name FROM Board_Heads) BH ON BH.HeadNo = BC.HeadNo
			LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
			WHERE BC.Enabled = TRUE AND BC.IsNotice = TRUE;
		
		END IF;
		
		IF IsRecommend = TRUE AND RecommendedDisplayCount > 0 THEN

			INSERT INTO TempTable
			SELECT BC.ContentNo, BC.Content, BC.ModUserNo, BC.ModUserName, BC.ModDepartNo, BC.ModDepartName, BC.RegDate, BC.Title, 0 AS TitleEffect,
				BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 0 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,
				
				COALESCE(BH.Name, '') AS HeadName, 1 AS IsRecommended ,

				BC.ModPositionNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

				BC.RegUserNo, 
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
		BC.RegPositionNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
		 BC.RegDepartNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
		,BC.IsAlarm
			FROM Board_Contents BC 
			LEFT JOIN (SELECT HeadNo, Name FROM Board_Heads) BH ON BH.HeadNo = BC.HeadNo
			LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
			WHERE BC.Enabled = TRUE AND BC.RecommendedCount > 0 and BC.IsNotice = FALSE
			ORDER BY RecommendedCount DESC;
		
		END IF;
	
		INSERT INTO TempTable
		SELECT BC.ContentNo, BC.Content, BC.ModUserNo, BC.ModUserName, BC.ModDepartNo, BC.ModDepartName, BC.RegDate, BC.Title, BC.TitleEffect,
			BC.GroupNo, BC.Depth, BC.OrderNo, BC.HeadNo, 0 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,
			
			COALESCE(BH.Name, '') AS HeadName, 0 AS IsRecommended,

			BC.ModPositionNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

				BC.RegUserNo, 
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
		BC.RegPositionNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
		 BC.RegDepartNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
		,BC.IsAlarm
		FROM SearchResult T
		INNER JOIN Board_Contents BC ON BC.ContentNo = T.ContentNo
		LEFT JOIN (SELECT HeadNo, Name FROM Board_Heads) BH ON BH.HeadNo = BC.HeadNo
		LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
		WHERE T.RowNum BETWEEN StartRowNum AND EndRowNum and BC.IsNotice = FALSE
		ORDER BY T.RowNum ASC;

	
	ELSE
	
		IF IsNotice = TRUE THEN
		
			INSERT INTO TempTable
			SELECT BC.ContentNo, BC.Content, BC.ModUserNo, BC.ModUserName, BC.ModDepartNo, BC.ModDepartName, BC.RegDate, BC.Title, 0 AS TitleEffect,
				BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 1 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,
				
				'' AS HeadName, 0 AS IsRecommended,

				BC.ModPositionNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

				BC.RegUserNo, 
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
		BC.RegPositionNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
		 BC.RegDepartNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
		,BC.IsAlarm
			FROM Board_Contents BC
			LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
			WHERE BC.IsNotice = TRUE AND BC.Enabled = TRUE;
		
		END IF;
		
		IF IsRecommend = TRUE AND RecommendedDisplayCount > 0 THEN

			INSERT INTO TempTable
			SELECT BC.ContentNo, BC.Content, BC.ModUserNo, BC.ModUserName, BC.ModDepartNo, BC.ModDepartName, BC.RegDate, BC.Title, 0 AS TitleEffect,
				BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 0 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,
				
				'' AS HeadName, 1 AS IsRecommended,

				BC.ModPositionNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

				BC.RegUserNo, 
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
		BC.RegPositionNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
		 BC.RegDepartNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
		,BC.IsAlarm
			FROM Board_Contents BC
			LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
			WHERE BC.RecommendedCount > 0 AND BC.Enabled = TRUE and BC.IsNotice = FALSE
			ORDER BY RecommendedCount DESC;
		
		END IF;
		
		INSERT INTO TempTable
		SELECT BC.ContentNo, BC.Content, BC.ModUserNo, BC.ModUserName, BC.ModDepartNo, BC.ModDepartName, BC.RegDate, BC.Title, BC.TitleEffect,
			BC.GroupNo, BC.Depth, BC.OrderNo, BC.HeadNo, 0 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,
			
			'' AS HeadName, 0 AS IsRecommended,

			BC.ModPositionNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

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
		ORDER BY T.RowNum ASC;

	END IF;

	RETURN QUERY
	SELECT * , (Select Count(*) From Board_ViewedLogs where Board_ViewedLogs.UserNo=board_web_search.userno AND BC.ContentNo=Board_ViewedLogs.ContentNo) As ReadCount , (SELECT BF.Name FROM Board_Files BF WHERE BF.ContentNo=BC.ContentNo AND (BF.Name ILIKE '%.gif' OR BF.Name ILIKE '%.png' OR BF.Name ILIKE '%.jpg' OR BF.Name ILIKE '%.jpeg' )) As AvataContent  FROM TempTable As BC
	
	RETURN QUERY
	SELECT TotalItemCount AS TotalContentCount, TotalPageCount AS TotalPageCount, CurrentPageIndex AS CurrentPageIndex;
END IF;
END IF;
END IF;
END IF;
END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.