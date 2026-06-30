-- ─── PROCEDURE→FUNCTION: board_getlistcommentsetting ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.board_getlistcommentsetting(character varying);
CREATE OR REPLACE FUNCTION public.board_getlistcommentsetting(
    IN langcode character varying DEFAULT 'EN'
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT B.BoardNo,B.ModUserNo, B.ModDate, 
		CASE WHEN STRPOS(B.Name, '{')>0 THEN (SELECT /* /* TOP 1 */ */ StringValue FROM ParseJson(B.Name)  WHERE NAME=board_getlistcommentsetting.langcode) ELSE B.Name END AS Name 
		, B.Description, B.FolderNo, B.DisplayTypeNo,
		B.SortNo, B.IsReply, B.IsHead, B.IsNotice, B.IsRecommend, B.RecommendedDisplayCount,B.ViewMode, B.Enabled,B.SpecType
	FROM Board_CommentSetting W
	INNER JOIN Board_Boards B ON W.BoardNo=B.BoardNo
	WHERE W.IsDelete = FALSE
	ORDER BY RegDate DESC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
