-- ─── FUNCTION: schedule_gettoken ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_gettoken(integer);
CREATE OR REPLACE FUNCTION public.schedule_gettoken(
    p_uno integer
) RETURNS TABLE(
    id serial,
    uno integer,
    tokendata text,
    lastupdated timestamp without time zone
)
AS $function$
BEGIN

 RETURN QUERY
 select * from ScheduleUserGoogleTokens 
	where UNo = schedule_gettoken.p_uno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
