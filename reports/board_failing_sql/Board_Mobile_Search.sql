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
	/*
	 * 정렬 컬럼
	 */

	IF SortColumn = 1 THEN
	    query := COALESCE(query, '') || COALESCE(('GroupNo '), '');
	END IF;



	/*
	 * 정렬 내림차순 여부
	 */

	IF IsAscending = TRUE THEN
	    query := COALESCE(query, '') || COALESCE(('ASC '), '');
	ELSE
	    query := COALESCE(query, '') || COALESCE(('DESC '), '');
	END IF;


	query := COALESCE(query, '') || COALESCE((', OrderNo ASC'), '');



	/*
	 * WHERE 조합 시작
	 */;

	query := COALESCE(query, '') || COALESCE((') RowNum, ContentNo, Content ' || 'FROM Board_Contents WHERE (Title ILIKE ''%' || SearchText || '%'' OR ModUserName ILIKE ''%' || SearchText || '%'') AND  Enabled = TRUE '), '');
		RAISE NOTICE '%', Query;

	/*
	 * 게시글 검색 시작
	 */

	CREATE TEMP TABLE SearchResult (
		RowNum		BIGINT,

		ContentNo	BIGINT,
		Content		text
	) ON COMMIT DROP;
	EXECUTE 'INSERT INTO SearchResult ' || query;
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
	IF CurrentPageIndex > TotalPageCount THEN
	    CurrentPageIndex := TotalPageCount;
	END IF;

	StartRowNum := ((CurrentPageIndex - 1) * CountPerPage) + 1;
	EndRowNum := board_mobile_search.currentpageindex * CountPerPage;
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
		FileCount			INT
	) ON COMMIT DROP;




	SELECT IsHead, IsNotice, IsRecommend, RecommendedDisplayCount INTO ishead, isnotice, isrecommend, recommendeddisplaycount FROM Board_Boards;


	IF IsHead = TRUE THEN

		IF IsNotice = TRUE THEN

			INSERT INTO TempTable
			SELECT BC.ContentNo, BC.Content, BC.ModUserNo, BC.ModUserName, BC.ModDepartNo, BC.ModDepartName, BC.RegDate, BC.Title, 0 AS TitleEffect,
				BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 1 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

				COALESCE(BH.Name, '') AS HeadName, 0 AS IsRecommended, BC.ModPositionNo, BC.ModPositionName,BC.FileCount
			FROM Board_Contents BC
			LEFT JOIN (SELECT HeadNo, Name FROM Board_Heads) BH ON BH.HeadNo = BC.HeadNo
			WHERE BC.Enabled = TRUE AND BC.IsNotice = TRUE;

		END IF;

		IF IsRecommend = TRUE AND RecommendedDisplayCount > 0 THEN

			INSERT INTO TempTable
			SELECT BC.ContentNo, BC.Content, BC.ModUserNo, BC.ModUserName, BC.ModDepartNo, BC.ModDepartName, BC.RegDate, BC.Title, 0 AS TitleEffect,
				BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 0 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

				COALESCE(BH.Name, '') AS HeadName, 1 AS IsRecommended , BC.ModPositionNo, BC.ModPositionName,BC.FileCount
			FROM Board_Contents BC
			LEFT JOIN (SELECT HeadNo, Name FROM Board_Heads) BH ON BH.HeadNo = BC.HeadNo
			WHERE BC.Enabled = TRUE AND BC.RecommendedCount > 0 and BC.IsNotice = FALSE
			ORDER BY RecommendedCount DESC;

		END IF;

		INSERT INTO TempTable
		SELECT BC.ContentNo, BC.Content, BC.ModUserNo, BC.ModUserName, BC.ModDepartNo, BC.ModDepartName, BC.RegDate, BC.Title, BC.TitleEffect,
			BC.GroupNo, BC.Depth, BC.OrderNo, BC.HeadNo, 0 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

			COALESCE(BH.Name, '') AS HeadName, 0 AS IsRecommended, BC.ModPositionNo, BC.ModPositionName,BC.FileCount
		FROM SearchResult T
		INNER JOIN Board_Contents BC ON BC.ContentNo = T.ContentNo
		LEFT JOIN (SELECT HeadNo, Name FROM Board_Heads) BH ON BH.HeadNo = BC.HeadNo
		WHERE T.RowNum BETWEEN StartRowNum AND EndRowNum and BC.IsNotice = FALSE
		ORDER BY T.RowNum ASC;


	ELSE

		IF IsNotice = TRUE THEN

			INSERT INTO TempTable
			SELECT BC.ContentNo, BC.Content, BC.ModUserNo, BC.ModUserName, BC.ModDepartNo, BC.ModDepartName, BC.RegDate, BC.Title, 0 AS TitleEffect,
				BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 1 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

				'' AS HeadName, 0 AS IsRecommended, BC.ModPositionNo, BC.ModPositionName,BC.FileCount
			FROM Board_Contents BC
			WHERE BC.IsNotice = TRUE AND BC.Enabled = TRUE;

		END IF;

		IF IsRecommend = TRUE AND RecommendedDisplayCount > 0 THEN

			INSERT INTO TempTable
			SELECT BC.ContentNo, BC.Content, BC.ModUserNo, BC.ModUserName, BC.ModDepartNo, BC.ModDepartName, BC.RegDate, BC.Title, 0 AS TitleEffect,
				BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 0 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

				'' AS HeadName, 1 AS IsRecommended, BC.ModPositionNo, BC.ModPositionName,BC.FileCount
			FROM Board_Contents BC
			WHERE BC.RecommendedCount > 0 AND BC.Enabled = TRUE and BC.IsNotice = FALSE
			ORDER BY RecommendedCount DESC;

		END IF;

		INSERT INTO TempTable
		SELECT BC.ContentNo, BC.Content, BC.ModUserNo, BC.ModUserName, BC.ModDepartNo, BC.ModDepartName, BC.RegDate, BC.Title, BC.TitleEffect,
			BC.GroupNo, BC.Depth, BC.OrderNo, BC.HeadNo, 0 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

			'' AS HeadName, 0 AS IsRecommended, BC.ModPositionNo, BC.ModPositionName,BC.FileCount
		FROM SearchResult T
		INNER JOIN Board_Contents BC ON BC.ContentNo = T.ContentNo
		WHERE T.RowNum BETWEEN StartRowNum AND EndRowNum and BC.IsNotice = FALSE
		ORDER BY T.RowNum ASC;

	END IF;

	RETURN QUERY
	SELECT * FROM TempTable;
	RETURN QUERY
	SELECT TotalItemCount AS TotalContentCount, TotalPageCount AS TotalPageCount, CurrentPageIndex AS CurrentPageIndex;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.