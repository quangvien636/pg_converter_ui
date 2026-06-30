-- ─── PROCEDURE→FUNCTION: board_getsettingcommunitywidget ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.board_getsettingcommunitywidget(character varying);
CREATE OR REPLACE FUNCTION public.board_getsettingcommunitywidget(
    IN langcode character varying DEFAULT 'EN'
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	RETURN QUERY
	SELECT B.BoardNo,B.ModUserNo, B.ModDate, 
		COALESCE(CASE WHEN STRPOS(B.Name, '{')>0 THEN COALESCE((SELECT /* /* TOP 1 */ */ StringValue FROM ParseJson(B.Name)  WHERE B.NAME=board_getsettingcommunitywidget.langcode),(SELECT /* /* TOP 1 */ */ StringValue FROM ParseJson(B.Name)  WHERE NAME='KO')) ELSE B.Name END,'') AS Name 
		, B.Description, B.FolderNo, B.DisplayTypeNo,
		B.SortNo, B.IsReply, B.IsHead, B.IsNotice, B.IsRecommend, B.RecommendedDisplayCount,B.ViewMode, B.Enabled,B.SpecType
	FROM Board_NewBoardWidget W
	INNER JOIN Board_Boards B ON W.BoardNo=B.BoardNo
	WHERE W.IsDelete = FALSE AND W.Type=2
	ORDER BY W.Sort DESC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
