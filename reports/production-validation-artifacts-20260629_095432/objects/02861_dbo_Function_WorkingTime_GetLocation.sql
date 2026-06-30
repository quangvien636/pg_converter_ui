-- ─── FUNCTION: workingtime_getlocation ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getlocation(integer);
CREATE OR REPLACE FUNCTION public.workingtime_getlocation(
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
    description text,
    enabled text,
    description2 text,
    usename text,
    name_en text,
    representation text,
    phonenumber text,
    col17 text,
    col18 text,
    col19 text,
    col20 text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT w.LocationNo, w.RegUserNo, w.RegDate, w.ModUserNo, w.ModDate, w.Name, w.Latitude, w.Longitude, w.ErrorRange, w.Description, w.Enabled, w.Description2
				   ,U.NAME AS UseName
				   ,u.Name_EN
				   ,W.Representation
				   ,W.PhoneNumber
				   , 0 TType
				, COALESCE(w.GType,0) GType
				, COALESCE(w.uids,'') UserNos
				, COALESCE(w.dids,'') DepartNos
	FROM WorkingTime_Locations w
	LEFT JOIN Organization_Users U ON W.RegUserNo = U .UserNo
	WHERE LocationNo = workingtime_getlocation.locationno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
