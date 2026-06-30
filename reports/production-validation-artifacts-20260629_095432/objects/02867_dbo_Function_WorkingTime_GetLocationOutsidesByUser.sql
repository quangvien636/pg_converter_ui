-- ─── FUNCTION: workingtime_getlocationoutsidesbyuser ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getlocationoutsidesbyuser(integer);
CREATE OR REPLACE FUNCTION public.workingtime_getlocationoutsidesbyuser(
    userno integer
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
    representation text,
    phonenumber text,
    description text,
    enabled text,
    usename text,
    name_en text
)
AS $function$
BEGIN


		RETURN QUERY
		SELECT W.LocationNo, W.RegUserNo, W.RegDate, W.ModUserNo, W.ModDate, W.Name, W.Latitude, W.Longitude, W.ErrorRange,W.Representation,W.PhoneNumber, Description, w.Enabled,
			   U.NAME AS UseName,
			   u.Name_EN
		FROM WorkingTime_LocationsOutside w
		LEFT JOIN Organization_Users U ON W.RegUserNo = U .UserNo
		WHERE W.RegUserNo = workingtime_getlocationoutsidesbyuser.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
