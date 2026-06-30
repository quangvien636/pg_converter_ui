-- ─── PROCEDURE→FUNCTION: schedule_insertoken ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_insertoken(integer);
CREATE OR REPLACE FUNCTION public.schedule_insertoken(
    IN p_uno integer
) RETURNS void
AS $function$
BEGIN

 INSERT INTO ScheduleUserGoogleTokens(UNo, TokenData, LastUpdated) 
 VALUES(p_uno, p_d, NOW());
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
