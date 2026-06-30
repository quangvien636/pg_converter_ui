-- ─── PROCEDURE→FUNCTION: workingtime_getlocationoutsidesrang ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_getlocationoutsidesrang(double precision, double precision, double precision);
CREATE OR REPLACE FUNCTION public.workingtime_getlocationoutsidesrang(
    IN p_lat double precision,
    IN p_lon double precision,
    IN p_rang double precision
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
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
