-- ─── FUNCTION: workingtime_getlocationoutsidesrang ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getlocationoutsidesrang(double precision, double precision, double precision);
CREATE OR REPLACE FUNCTION public.workingtime_getlocationoutsidesrang(
    p_lat double precision,
    p_lon double precision,
    p_rang double precision
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
    col10 text,
    col11 text,
    description text,
    enabled text,
    usename text,
    name_en text
)
AS $function$
BEGIN


		RETURN QUERY
		SELECT W.LocationNo, W.RegUserNo, W.RegDate, W.ModUserNo, W.ModDate, W.Name, W.Latitude, W.Longitude, W.ErrorRange,COALESCE( W.Representation,'') Representation, COALESCE(W.PhoneNumber,'') PhoneNumber, Description, w.Enabled,
				U.NAME AS UseName,
				u.Name_EN
		FROM WorkingTime_LocationsOutside w
		LEFT JOIN Organization_Users U ON W.RegUserNo = U .UserNo
		where orig.STDistance(geography::Point(w.Latitude, w.Longitude, 4326))   < workingtime_getlocationoutsidesrang.p_rang
		Order by w.LocationNo desc;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
