-- ─── FUNCTION: workingtime_getworkingtime_locations ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getworkingtime_locations();
CREATE OR REPLACE FUNCTION public.workingtime_getworkingtime_locations(
) RETURNS TABLE(
    locationno text,
    reguserno text,
    regdate text,
    moduserno text,
    moddate text,
    name text,
    latitude text,
    longitude text,
    errorrange text,
    description text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT LocationNo, RegUserNo, RegDate, ModUserNo, ModDate,
		Name, Latitude, Longitude, ErrorRange, Description
	FROM WorkingTime_Locations;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
