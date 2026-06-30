-- ─── PROCEDURE→FUNCTION: workingtime_getlocationoutsidesbyuseranddate ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_getlocationoutsidesbyuseranddate(integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_getlocationoutsidesbyuseranddate(
    IN userno integer,
    IN datecheck integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
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
