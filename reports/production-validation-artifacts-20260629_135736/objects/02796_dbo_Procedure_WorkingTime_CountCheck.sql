-- ─── PROCEDURE→FUNCTION: workingtime_countcheck ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_countcheck(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_countcheck(
    IN p_uno integer,
    IN p_day integer,
    IN p_type integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT COUNT(1) AS CheckCount FROM WorkingTime_Times w
	WHERE w.UserNo = workingtime_countcheck.p_uno AND W.WorkingDayC = workingtime_countcheck.p_day and (w.TimeType = workingtime_countcheck.p_type or w.TimeType < 0);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
