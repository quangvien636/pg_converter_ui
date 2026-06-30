-- ─── FUNCTION: workingtime_getbeaconpoint ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getbeaconpoint(integer);
CREATE OR REPLACE FUNCTION public.workingtime_getbeaconpoint(
    pointno integer
) RETURNS TABLE(
    pointno text,
    moduserno text,
    moddate text,
    locationno text,
    beaconuuid text,
    beaconmajor text,
    beaconminor text,
    officename text,
    officelatitude text,
    officelongitude text,
    officeerrorrange text,
    officedescription text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT P.PointNo, P.ModUserNo, P.ModDate, P.LocationNo, P.BeaconUUID, P.BeaconMajor, P.BeaconMinor,
		L.Name AS OfficeName, L.Latitude AS OfficeLatitude, L.Longitude AS OfficeLongitude,
		L.ErrorRange AS OfficeErrorRange, L.Description AS OfficeDescription
	FROM WorkingTime_BeaconPoints AS P
	INNER JOIN WorkingTime_Locations AS L ON L.LocationNo = P.LocationNo
	WHERE P.PointNo = workingtime_getbeaconpoint.pointno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
