-- ─── PROCEDURE→FUNCTION: workingtime_getbeaconpoints ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_getbeaconpoints();
CREATE OR REPLACE FUNCTION public.workingtime_getbeaconpoints(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT P.PointNo, P.ModUserNo, P.ModDate, P.LocationNo, P.BeaconUUID, P.BeaconMajor, P.BeaconMinor,
		L.Name AS OfficeName, L.Latitude AS OfficeLatitude, L.Longitude AS OfficeLongitude,
		L.ErrorRange AS OfficeErrorRange, L.Description AS OfficeDescription
	FROM WorkingTime_BeaconPoints AS P
	INNER JOIN WorkingTime_Locations AS L ON L.LocationNo = P.LocationNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
