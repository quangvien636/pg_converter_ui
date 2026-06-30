-- ─── PROCEDURE→FUNCTION: board_mobile_search ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: Dynamic SQL detected. Manual rewrite required for PostgreSQL.
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.board_mobile_search(character varying, integer, boolean, integer, integer);
CREATE OR REPLACE FUNCTION public.board_mobile_search(
    IN searchtext character varying,
    IN sortcolumn integer,
    IN isascending boolean,
    IN countperpage integer,
    IN currentpageindex integer
) RETURNS SETOF record
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
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	/*
	 * 쿼리 조합 시작
	 */


	Query := 'SELECT ROW_NUMBER() OVER (ORDER BY ';
	/*
	 * 정렬 컬럼
	 */
	 
	IF (SortColumn = 1) SET Query += 'GroupNo ' THEN



	/*
	 * 정렬 내림차순 여부
	 */
	 
	IF (IsAscending = TRUE) SET Query += 'ASC ' THEN
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
	PERFORM query();
	/*
	 * 페이징 계산
	 */





	TotalItemCount := (SELECT COUNT(*) FROM SearchResult);
	TotalPageCount := TotalItemCount / CountPerPage;
	IF (TotalPageCount % CountPerPage > 0) SET TotalPageCount = TotalPageCount + 1 THEN
	IF (TotalPageCount = 0) SET TotalPageCount = 1 THEN
	IF (CurrentPageIndex > TotalPageCount) SET CurrentPageIndex = TotalPageCount THEN

	StartRowNum := ((CurrentPageIndex - 1) * CountPerPage) + 1;
	EndRowNum := board_mobile_search.currentpageindex * CountPerPage;
	/*
	 *
	 */
	 
	,
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
	


	SELECT IsHead, IsNotice, IsRecommend INTO ishead, isnotice, isrecommend FROM Board_Boards
	
	IF IsHead = TRUE THEN
	
		IF IsNotice = TRUE THEN
		
			INSERT INTO TempTable
			RETURN QUERY
			SELECT BC.ContentNo, BC.Content, BC.ModUserNo, BC.ModUserName, BC.ModDepartNo, BC.ModDepartName, BC.RegDate, BC.Title, 0 AS TitleEffect,
				BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 1 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,
				
				COALESCE(BH.Name, '') AS HeadName, 0 AS IsRecommended, BC.ModPositionNo, BC.ModPositionName,BC.FileCount
			FROM Board_Contents BC
			LEFT JOIN (SELECT HeadNo, Name FROM Board_Heads) BH ON BH.HeadNo = BC.HeadNo
			WHERE BC.Enabled = TRUE AND BC.IsNotice = TRUE
		
		END IF;
		
		IF IsRecommend = TRUE AND RecommendedDisplayCount > 0 THEN

			INSERT INTO TempTable
			RETURN QUERY
			SELECT TOP (RecommendedDisplayCount) BC.ContentNo, BC.Content, BC.ModUserNo, BC.ModUserName, BC.ModDepartNo, BC.ModDepartName, BC.RegDate, BC.Title, 0 AS TitleEffect,
				BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 0 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,
				
				COALESCE(BH.Name, '') AS HeadName, 1 AS IsRecommended , BC.ModPositionNo, BC.ModPositionName,BC.FileCount
			FROM Board_Contents BC 
			LEFT JOIN (SELECT HeadNo, Name FROM Board_Heads) BH ON BH.HeadNo = BC.HeadNo
			WHERE BC.Enabled = TRUE AND BC.RecommendedCount > 0 and BC.IsNotice = FALSE
			ORDER BY RecommendedCount DESC
		
		END IF;
	
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

	END IF;
	
	ELSE BEGIN
	
		IF IsNotice = TRUE THEN
		
			INSERT INTO TempTable
			RETURN QUERY
			SELECT BC.ContentNo, BC.Content, BC.ModUserNo, BC.ModUserName, BC.ModDepartNo, BC.ModDepartName, BC.RegDate, BC.Title, 0 AS TitleEffect,
				BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 1 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,
				
				'' AS HeadName, 0 AS IsRecommended, BC.ModPositionNo, BC.ModPositionName,BC.FileCount
			FROM Board_Contents BC
			WHERE BC.IsNotice = TRUE AND BC.Enabled = TRUE
		
		END IF;
		
		IF IsRecommend = TRUE AND RecommendedDisplayCount > 0 THEN

			INSERT INTO TempTable
			RETURN QUERY
			SELECT TOP (RecommendedDisplayCount) BC.ContentNo, BC.Content, BC.ModUserNo, BC.ModUserName, BC.ModDepartNo, BC.ModDepartName, BC.RegDate, BC.Title, 0 AS TitleEffect,
				BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 0 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,
				
				'' AS HeadName, 1 AS IsRecommended, BC.ModPositionNo, BC.ModPositionName,BC.FileCount
			FROM Board_Contents BC
			WHERE BC.RecommendedCount > 0 AND BC.Enabled = TRUE and BC.IsNotice = FALSE
			ORDER BY RecommendedCount DESC
		
		END IF;
		
		INSERT INTO TempTable
		RETURN QUERY
		SELECT BC.ContentNo, BC.Content, BC.ModUserNo, BC.ModUserName, BC.ModDepartNo, BC.ModDepartName, BC.RegDate, BC.Title, BC.TitleEffect,
			BC.GroupNo, BC.Depth, BC.OrderNo, BC.HeadNo, 0 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,
			
			'' AS HeadName, 0 AS IsRecommended, BC.ModPositionNo, BC.ModPositionName,BC.FileCount
		FROM SearchResult T
		INNER JOIN Board_Contents BC ON BC.ContentNo = T.ContentNo
		WHERE T.RowNum BETWEEN StartRowNum AND EndRowNum and BC.IsNotice = FALSE
		ORDER BY T.RowNum ASC

	END;

	RETURN QUERY
	SELECT * FROM TempTable
	RETURN QUERY
	SELECT TotalItemCount AS TotalContentCount, TotalPageCount AS TotalPageCount, CurrentPageIndex AS CurrentPageIndex;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
