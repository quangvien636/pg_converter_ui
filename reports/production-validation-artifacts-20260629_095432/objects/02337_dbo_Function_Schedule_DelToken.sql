-- ─── FUNCTION: schedule_deltoken ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_deltoken(integer);
CREATE OR REPLACE FUNCTION public.schedule_deltoken(
    p_uno integer
) RETURNS void
AS $function$
BEGIN

 DELETE FROM ScheduleUserGoogleTokens 
	where Uno = schedule_deltoken.p_uno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
