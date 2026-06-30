-- ─── PROCEDURE→FUNCTION: schedule_getresourcerepaircheck ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_getresourcerepaircheck();
CREATE OR REPLACE FUNCTION public.schedule_getresourcerepaircheck(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT COUNT(ResourceNo) AS CNT 
	FROM ScheduleResourcesRepair
	WHERE ResourceNo = ResourceNo
	AND Status <> 'F';
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
