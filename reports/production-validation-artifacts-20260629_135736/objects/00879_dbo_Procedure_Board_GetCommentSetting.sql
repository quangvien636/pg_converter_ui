-- ─── PROCEDURE→FUNCTION: board_getcommentsetting ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.board_getcommentsetting(integer);
CREATE OR REPLACE FUNCTION public.board_getcommentsetting(
    IN boardno integer DEFAULT 1213
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT COUNT(*)  FROM 
	Board_CommentSetting BC

	WHERE  BC.BoardNo= board_getcommentsetting.boardno AND BC.IsDelete= FALSE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
