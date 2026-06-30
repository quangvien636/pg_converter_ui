-- ─── FUNCTION: schedule_insertoken ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_insertoken(integer);
CREATE OR REPLACE FUNCTION public.schedule_insertoken(
    p_uno integer
) RETURNS void
AS $function$
BEGIN

 INSERT INTO ScheduleUserGoogleTokens(UNo, TokenData, LastUpdated) 
 VALUES(p_uno, p_d, NOW());
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
