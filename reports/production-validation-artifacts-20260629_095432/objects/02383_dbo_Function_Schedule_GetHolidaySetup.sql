-- ─── FUNCTION: schedule_getholidaysetup ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getholidaysetup();
CREATE OR REPLACE FUNCTION public.schedule_getholidaysetup(
) RETURNS TABLE(
    no serial,
    show boolean,
    url character varying(4000),
    key character varying(4000)
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT
		*
	FROM HolidaySetup;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
