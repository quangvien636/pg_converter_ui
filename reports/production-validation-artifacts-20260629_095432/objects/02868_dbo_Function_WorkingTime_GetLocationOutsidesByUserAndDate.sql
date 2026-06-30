-- ─── FUNCTION: workingtime_getlocationoutsidesbyuseranddate ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getlocationoutsidesbyuseranddate(integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_getlocationoutsidesbyuseranddate(
    userno integer,
    datecheck integer
) RETURNS TABLE(
    reguserno text,
    workingno text,
    locationno text,
    name text,
    latitude text,
    longitude text,
    errorrange text,
    representation text,
    phonenumber text,
    description text,
    enabled text,
    col12 text,
    name_en text,
    regdate text
)
AS $function$
BEGIN

		RETURN QUERY
		SELECT T.RegUserNo 
			   ,T.WorkingNo
			   ,T.LocationNo
			   ,W.Name
			   ,W.Latitude
			   ,W.Longitude
			   ,W.ErrorRange
			   ,W.Representation
			   ,W.PhoneNumber
			   ,W.Description
			   ,W.Enabled
			   ,U.Name UseName
			   ,U.Name_EN
			   ,W.RegDate
		FROM WorkingTime_Times T
		JOIN WorkingTime_LocationsOutside W 
		ON T.LocationNo = W.LocationNo
		LEFT JOIN Organization_Users U ON U.UserNo = T.UserNo 
		WHERE T.UserNo = workingtime_getlocationoutsidesbyuseranddate.userno AND T.WorkingDay = workingtime_getlocationoutsidesbyuseranddate.datecheck;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
