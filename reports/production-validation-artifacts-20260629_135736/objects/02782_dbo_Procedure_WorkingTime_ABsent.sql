-- ─── PROCEDURE→FUNCTION: workingtime_absent ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_absent(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_absent(
    IN p_from integer,
    IN p_to integer,
    IN p_uid integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	select c.WorkingDayC from WorkingTime_Times c 
	where c.UserNo = workingtime_absent.p_uid and c.WorkingDayC between p_From and p_To;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
