-- ─── FUNCTION: workingtime_locationlistgetsingle ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_locationlistgetsingle(integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_locationlistgetsingle(
    userno integer,
    id integer
) RETURNS TABLE(
    id serial,
    name character varying(250),
    dayadd integer,
    timeadd character varying(250),
    distance double precision,
    lat double precision,
    lng double precision,
    userno integer
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT * FROM WorkingTime_LocationList
	WHERE id=workingtime_locationlistgetsingle.id AND userno=workingtime_locationlistgetsingle.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
