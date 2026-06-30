-- ─── FUNCTION: workingtime_getsetupitem ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getsetupitem();
CREATE OR REPLACE FUNCTION public.workingtime_getsetupitem(
) RETURNS TABLE(
    id serial,
    checkin character varying(2),
    checkout character varying(2),
    workoutside character varying(2),
    returnv character varying(2),
    wfh character varying(2),
    early character varying(2),
    nightwork character varying(2),
    extension character varying(2),
    training character varying(2),
    holiday character varying(2),
    quatertoff character varying(2),
    haftoff character varying(2),
    alloff character varying(2)
)
AS $function$
BEGIN

	
	RETURN QUERY
	SELECT * FROM WorkingTime_setupitems;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
