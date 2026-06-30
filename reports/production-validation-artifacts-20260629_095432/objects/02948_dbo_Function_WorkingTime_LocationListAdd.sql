-- ─── FUNCTION: workingtime_locationlistadd ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_locationlistadd(integer, character varying, integer, character varying, double precision, double precision, double precision);
CREATE OR REPLACE FUNCTION public.workingtime_locationlistadd(
    userno integer,
    name character varying,
    dayadd integer,
    timeadd character varying,
    distance double precision,
    lat double precision,
    lng double precision
) RETURNS void
AS $function$
BEGIN

	INSERT INTO WorkingTime_LocationList(name,dayadd,timeadd,distance,lat,lng,userno)
	VALUES (name,dayadd,timeadd,distance,lat,lng,userno);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
