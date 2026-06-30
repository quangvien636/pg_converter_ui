-- ─── PROCEDURE→FUNCTION: workingtime_workingtime ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_workingtime(integer);
CREATE OR REPLACE FUNCTION public.workingtime_workingtime(
    IN p_no integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	
	RETURN QUERY
	SELECT *
	FROM WorkingTime_Times  T
	WHERE WorkingNo =  workingtime_workingtime.p_no;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
