-- ─── PROCEDURE→FUNCTION: schedule_updatetoken ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_updatetoken(integer);
CREATE OR REPLACE FUNCTION public.schedule_updatetoken(
    IN p_uno integer
) RETURNS void
AS $function$
BEGIN

 update ScheduleUserGoogleTokens set TokenData = p_d
	, LastUpdated = NOW() 
	where Uno = schedule_updatetoken.p_uno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
