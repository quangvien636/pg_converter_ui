-- ─── FUNCTION: schedule_getconfig ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getconfig();
CREATE OR REPLACE FUNCTION public.schedule_getconfig(
) RETURNS TABLE(
    id serial,
    configname character varying(100),
    domainname character varying(500),
    jsondata text,
    createdat timestamp without time zone
)
AS $function$
BEGIN

 RETURN QUERY
 select * from ScheduleGoogleAppConfigs 
	where ConfigName = p_n;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
