-- ─── PROCEDURE→FUNCTION: workingtime_getcheckoutbyday ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_getcheckoutbyday(integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_getcheckoutbyday(
    IN p_day integer,
    IN p_uno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT *
	FROM WorkingTime_Times W 
	WHERE w.WorkingDayC = workingtime_getcheckoutbyday.p_day and w.TimeType = 3 and w.Userno = workingtime_getcheckoutbyday.p_uno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
