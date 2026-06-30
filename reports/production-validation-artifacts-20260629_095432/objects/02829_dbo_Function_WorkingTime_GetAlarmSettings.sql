-- ─── FUNCTION: workingtime_getalarmsettings ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getalarmsettings();
CREATE OR REPLACE FUNCTION public.workingtime_getalarmsettings(
) RETURNS TABLE(
    id integer,
    isalarm integer,
    type integer,
    altext character varying(400),
    altexten character varying(400),
    altextjp character varying(400),
    altextvi character varying(400),
    altextci character varying(400)
)
AS $function$
BEGIN


	RETURN QUERY
	select * from WorkingTime_AlarmSetting;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
