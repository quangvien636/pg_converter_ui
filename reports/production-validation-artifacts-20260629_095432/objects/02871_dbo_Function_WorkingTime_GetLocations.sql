-- ─── FUNCTION: workingtime_getlocations ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getlocations();
CREATE OR REPLACE FUNCTION public.workingtime_getlocations(
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
    description text,
    enabled text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT LocationNo, RegUserNo, RegDate, ModUserNo, ModDate, Name, Latitude, Longitude, ErrorRange, Description, Enabled
	FROM WorkingTime_Locations;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
