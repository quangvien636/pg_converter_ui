-- ─── PROCEDURE→FUNCTION: schedule_getscheduleuds ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_getscheduleuds(date);
CREATE OR REPLACE FUNCTION public.schedule_getscheduleuds(
    IN p_date date
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT s.*
	FROM ScheduleContentUds S 
	WHERE s.StartDate >= schedule_getscheduleuds.p_date;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
