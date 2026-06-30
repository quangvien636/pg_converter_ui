-- ─── FUNCTION: workingtime_getlocationoutside ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getlocationoutside(integer);
CREATE OR REPLACE FUNCTION public.workingtime_getlocationoutside(
    locationno integer
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
    name_en text,
    description2 text,
    col17 text,
    col18 text
)
AS $function$
BEGIN


		RETURN QUERY
		SELECT W.LocationNo, W.RegUserNo, W.RegDate, W.ModUserNo, W.ModDate, W.Name, W.Latitude, W.Longitude, W.ErrorRange
		,COALESCE(W.Representation,'') Representation
		,COALESCE(W.PhoneNumber,'')  PhoneNumber
		, Description, w.Enabled,
			   U.NAME AS UseName,
			   u.Name_EN, Description2
			   , 1 TType
				, COALESCE(w.GType,0) GType
		FROM WorkingTime_LocationsOutside w
		LEFT JOIN Organization_Users U ON W.RegUserNo = U .UserNo
		WHERE W.LocationNo = workingtime_getlocationoutside.locationno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
