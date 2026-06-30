-- ─── PROCEDURE→FUNCTION: workingtime_settingsdefault ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_settingsdefault();
CREATE OR REPLACE FUNCTION public.workingtime_settingsdefault(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


   RETURN QUERY
   select S.*,U.UserId, U.Name, U.Name_EN
   
    from WorkingTime_Settings S
	LEFT JOIN Organization_Users U
	ON S.RegUserNo = U.USERNO;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
