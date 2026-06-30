-- ─── PROCEDURE→FUNCTION: board_getrecommendedlogbyuserno ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.board_getrecommendedlogbyuserno(bigint, integer);
CREATE OR REPLACE FUNCTION public.board_getrecommendedlogbyuserno(
    IN contentno bigint,
    IN userno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT LogNo, BoardNo, ContentNo, UserNo, UserName, PositionNo, PositionName, DepartNo, DepartName,
		RecommendedDate
	FROM Board_RecommendedLogs
	WHERE ContentNo = board_getrecommendedlogbyuserno.contentno AND UserNo=board_getrecommendedlogbyuserno.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
