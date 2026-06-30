-- ─── PROCEDURE→FUNCTION: schedule_gettoken ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_gettoken(integer);
CREATE OR REPLACE FUNCTION public.schedule_gettoken(
    IN p_uno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

 RETURN QUERY
 select * from ScheduleUserGoogleTokens 
	where UNo = schedule_gettoken.p_uno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
