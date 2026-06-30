-- ─── PROCEDURE→FUNCTION: board_getrecommendedlogs ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.board_getrecommendedlogs(bigint);
CREATE OR REPLACE FUNCTION public.board_getrecommendedlogs(
    IN contentno bigint DEFAULT 8
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT LogNo, BoardNo, ContentNo, UserNo, UserName, PositionNo, PositionName, DepartNo, DepartName,
		RecommendedDate
	FROM Board_RecommendedLogs
	WHERE ContentNo = board_getrecommendedlogs.contentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
