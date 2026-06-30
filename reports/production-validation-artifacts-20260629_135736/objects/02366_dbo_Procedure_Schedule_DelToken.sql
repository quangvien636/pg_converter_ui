-- ─── PROCEDURE→FUNCTION: schedule_deltoken ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_deltoken(integer);
CREATE OR REPLACE FUNCTION public.schedule_deltoken(
    IN p_uno integer
) RETURNS void
AS $function$
BEGIN

 DELETE FROM ScheduleUserGoogleTokens 
	where Uno = schedule_deltoken.p_uno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
