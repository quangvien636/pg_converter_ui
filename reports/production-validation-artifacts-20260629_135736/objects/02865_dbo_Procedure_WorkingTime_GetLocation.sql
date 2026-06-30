-- ─── PROCEDURE→FUNCTION: workingtime_getlocation ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_getlocation(integer);
CREATE OR REPLACE FUNCTION public.workingtime_getlocation(
    IN locationno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
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
