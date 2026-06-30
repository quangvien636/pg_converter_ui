-- ─── PROCEDURE→FUNCTION: workingtime_getlocationoutside ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_getlocationoutside(integer);
CREATE OR REPLACE FUNCTION public.workingtime_getlocationoutside(
    IN locationno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
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
