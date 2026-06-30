-- ─── PROCEDURE→FUNCTION: workingtime_employeeon ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_employeeon(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_employeeon(
    IN p_from integer,
    IN p_to integer,
    IN p_uid integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	select * from WorkingTime_Calculater c 
	where c.UserNo = workingtime_employeeon.p_uid and c.WorkingDay between p_From and p_To;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
