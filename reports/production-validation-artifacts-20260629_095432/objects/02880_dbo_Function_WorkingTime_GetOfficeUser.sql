-- ─── FUNCTION: workingtime_getofficeuser ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getofficeuser(integer);
CREATE OR REPLACE FUNCTION public.workingtime_getofficeuser(
    userno integer
) RETURNS TABLE(
    userno text,
    locationno text,
    name text,
    userid text,
    description text,
    name text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT WO.UserNo,WO.LocationNo,O.Name,O.UserID,L.Description,L.Name from WorkingTime_Locations_Office WO
	INNER JOIN Organization_Users O
	ON WO.UserNo=O.UserNo
	RIGHT JOIN WorkingTime_Locations L
	ON WO.LocationNo=L.LocationNo
	WHERE WO.UserNo=workingtime_getofficeuser.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
