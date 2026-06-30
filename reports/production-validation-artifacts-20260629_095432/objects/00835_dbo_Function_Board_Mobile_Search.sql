-- ─── FUNCTION: board_mobile_search ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_mobile_search(character varying, integer, boolean, integer, integer);
CREATE OR REPLACE FUNCTION public.board_mobile_search(
    searchtext character varying,
    sortcolumn integer,
    isascending boolean,
    countperpage integer,
    currentpageindex integer
) RETURNS TABLE(
    contentno bigserial,
    boardno integer,
    moduserno integer,
    modusername character varying(100),
    modpositionno integer,
    modpositionname character varying(100),
    moddepartno integer,
    moddepartname character varying(100),
    regdate timestamp without time zone,
    moddate timestamp without time zone,
    title character varying(200),
    titleeffect integer,
    groupno bigint,
    depth integer,
    orderno integer,
    headno integer,
    isnotice boolean,
    content text,
    isfile boolean,
    filecount integer,
    replycount integer,
    recommendedcount integer,
    viewedcount integer,
    startdate timestamp without time zone,
    enddate timestamp without time zone,
    enabled boolean,
    reguserno integer,
    regpositionno integer,
    regdepartno integer,
    viewmode integer,
    isalarm boolean,
    rootid bigint,
    levelrand character varying(500),
    isshareall boolean,
    type character varying(1000),
    errortype character varying(1000),
    persontype character varying(1000),
    visitdate timestamp without time zone,
    visitcompletedate timestamp without time zone,
    dateview timestamp without time zone,
    designno character varying(1000),
    constructionname character varying(1000),
    applyto character varying(1000),
    important boolean,
    mailrecipientno text,
    mailrecipientname text,
    private boolean,
    businessdate timestamp without time zone,
    purpose character varying(1000),
    note character varying(1000),
    other text,
    inspector character varying(1000),
    generation character varying(1000),
    badno character varying(1000),
    standard character varying(1000),
    isrecommendpublic boolean,
    eappno integer
)
AS $function$
DECLARE
    query character varying;
    searchresult table (
		rownum		bigint,
		
		contentno	bigint,
		content		nvarchar(max);
    totalitemcount integer;
    totalpagecount integer;
    startrownum integer;
    endrownum integer;
    recommendeddisplaycount integer;
BEGIN


	/*
	 * 쿼리 조합 시작
	 */


	SET Query = 'SELECT ROW_NUMBER() OVER (ORDER BY '



	/*
	 * 정렬 컬럼
	 */
	 
	IF (SortColumn = 1) SET Query += 'GroupNo '



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
		') RowNum, ContentNo, Content ' +
		'FROM Board_Contents WHERE (Title ILIKE ''%' || SearchText || '%'' OR ModUserName ILIKE ''%' || SearchText || '%'') AND  Enabled = TRUE '
		RAISE NOTICE '%', Query
		
	/*
	 * 게시글 검색 시작
	 */
	 

	);
	INSERT INTO SearchResult
	EXEC SP_EXECUTESQL Query
		
		
		
	/*
	 * 페이징 계산
	 */





	SET TotalItemCount = (SELECT COUNT(*) FROM SearchResult)
	SET TotalPageCount = TotalItemCount / CountPerPage

	IF (TotalPageCount % CountPerPage > 0) SET TotalPageCount = TotalPageCount + 1
	IF (TotalPageCount = 0) SET TotalPageCount = 1
	IF (CurrentPageIndex > TotalPageCount) SET CurrentPageIndex = TotalPageCount

	SET StartRowNum = ((CurrentPageIndex - 1) * CountPerPage) + 1
	SET EndRowNum = board_mobile_search.currentpageindex * CountPerPage



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
		FileCount			INT
	)
	


	SELECT IsHead = IsHead, IsNotice = IsNotice, IsRecommend = IsRecommend, RecommendedDisplayCount = RecommendedDisplayCount
	FROM Board_Boards
	
	IF (IsHead = TRUE) BEGIN
	
		IF (IsNotice = TRUE) BEGIN
		
			INSERT INTO TempTable
			RETURN QUERY
			SELECT BC.ContentNo, BC.Content, BC.ModUserNo, BC.ModUserName, BC.ModDepartNo, BC.ModDepartName, BC.RegDate, BC.Title, 0 AS TitleEffect,
				BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 1 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,
				
				COALESCE(BH.Name, '') AS HeadName, 0 AS IsRecommended, BC.ModPositionNo, BC.ModPositionName,BC.FileCount
			FROM Board_Contents BC
			LEFT JOIN (SELECT HeadNo, Name FROM Board_Heads) BH ON BH.HeadNo = BC.HeadNo
			WHERE BC.Enabled = TRUE AND BC.IsNotice = TRUE
		
		END
		
		IF (IsRecommend = TRUE AND RecommendedDisplayCount > 0) BEGIN

			INSERT INTO TempTable
			RETURN QUERY
			SELECT TOP (RecommendedDisplayCount) BC.ContentNo, BC.Content, BC.ModUserNo, BC.ModUserName, BC.ModDepartNo, BC.ModDepartName, BC.RegDate, BC.Title, 0 AS TitleEffect,
				BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 0 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,
				
				COALESCE(BH.Name, '') AS HeadName, 1 AS IsRecommended , BC.ModPositionNo, BC.ModPositionName,BC.FileCount
			FROM Board_Contents BC 
			LEFT JOIN (SELECT HeadNo, Name FROM Board_Heads) BH ON BH.HeadNo = BC.HeadNo
			WHERE BC.Enabled = TRUE AND BC.RecommendedCount > 0 and BC.IsNotice = FALSE
			ORDER BY RecommendedCount DESC
		
		END
	
		INSERT INTO TempTable
		RETURN QUERY
		SELECT BC.ContentNo, BC.Content, BC.ModUserNo, BC.ModUserName, BC.ModDepartNo, BC.ModDepartName, BC.RegDate, BC.Title, BC.TitleEffect,
			BC.GroupNo, BC.Depth, BC.OrderNo, BC.HeadNo, 0 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,
			
			COALESCE(BH.Name, '') AS HeadName, 0 AS IsRecommended, BC.ModPositionNo, BC.ModPositionName,BC.FileCount
		FROM SearchResult T
		INNER JOIN Board_Contents BC ON BC.ContentNo = T.ContentNo
		LEFT JOIN (SELECT HeadNo, Name FROM Board_Heads) BH ON BH.HeadNo = BC.HeadNo
		WHERE T.RowNum BETWEEN StartRowNum AND EndRowNum and BC.IsNotice = FALSE
		ORDER BY T.RowNum ASC

	END
	
	ELSE BEGIN
	
		IF (IsNotice = TRUE) BEGIN
		
			INSERT INTO TempTable
			RETURN QUERY
			SELECT BC.ContentNo, BC.Content, BC.ModUserNo, BC.ModUserName, BC.ModDepartNo, BC.ModDepartName, BC.RegDate, BC.Title, 0 AS TitleEffect,
				BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 1 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,
				
				'' AS HeadName, 0 AS IsRecommended, BC.ModPositionNo, BC.ModPositionName,BC.FileCount
			FROM Board_Contents BC
			WHERE BC.IsNotice = TRUE AND BC.Enabled = TRUE
		
		END
		
		IF (IsRecommend = TRUE AND RecommendedDisplayCount > 0) BEGIN

			INSERT INTO TempTable
			RETURN QUERY
			SELECT TOP (RecommendedDisplayCount) BC.ContentNo, BC.Content, BC.ModUserNo, BC.ModUserName, BC.ModDepartNo, BC.ModDepartName, BC.RegDate, BC.Title, 0 AS TitleEffect,
				BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 0 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,
				
				'' AS HeadName, 1 AS IsRecommended, BC.ModPositionNo, BC.ModPositionName,BC.FileCount
			FROM Board_Contents BC
			WHERE BC.RecommendedCount > 0 AND BC.Enabled = TRUE and BC.IsNotice = FALSE
			ORDER BY RecommendedCount DESC
		
		END
		
		INSERT INTO TempTable
		RETURN QUERY
		SELECT BC.ContentNo, BC.Content, BC.ModUserNo, BC.ModUserName, BC.ModDepartNo, BC.ModDepartName, BC.RegDate, BC.Title, BC.TitleEffect,
			BC.GroupNo, BC.Depth, BC.OrderNo, BC.HeadNo, 0 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,
			
			'' AS HeadName, 0 AS IsRecommended, BC.ModPositionNo, BC.ModPositionName,BC.FileCount
		FROM SearchResult T
		INNER JOIN Board_Contents BC ON BC.ContentNo = T.ContentNo
		WHERE T.RowNum BETWEEN StartRowNum AND EndRowNum and BC.IsNotice = FALSE
		ORDER BY T.RowNum ASC

	END

	RETURN QUERY
	SELECT * FROM TempTable
	RETURN QUERY
	SELECT TotalItemCount AS TotalContentCount, TotalPageCount AS TotalPageCount, CurrentPageIndex AS CurrentPageIndex;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
