-- ─── PROCEDURE→FUNCTION: workingtime_getworkingtimelocations2 ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_getworkingtimelocations2();
CREATE OR REPLACE FUNCTION public.workingtime_getworkingtimelocations2(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


RETURN QUERY
SELECT l.LocationNo, L.RegUserNo, L.RegDate, l.ModUserNo, l.ModDate, l.Name, Latitude, Longitude, ErrorRange, Description, COALESCE(Description2,'') Description2, l.Enabled
		   , COALESCE(Representation,'') Representation
		   , COALESCE(PhoneNumber,'') PhoneNumber
		   , 0 TType
		   , COALESCE(G.GType,0) GType
		   , COALESCE(G.GName,'')  GName
		   , COALESCE(u.Name,'') UserName
		   , COALESCE(u.Name_EN,'') UserNameEn
	FROM WorkingTime_Locations L
	LEFT JOIN WorkingTime_GroupPlace G ON L.GType = G.GNo
	LEFT JOIN Organization_Users U ON L.RegUserNo = U .UserNo
	UNION ALL
	
	RETURN QUERY
	SELECT  l.LocationNo, L.RegUserNo, L.RegDate, l.ModUserNo, l.ModDate, l.Name, Latitude, Longitude, ErrorRange, Description, COALESCE(Description2,'') Description2, l.Enabled
		   , COALESCE(Representation,'') Representation
		   , COALESCE(PhoneNumber,'') PhoneNumber
		   , 1 TType
		   , COALESCE(G.GType,0) GType
		   , COALESCE(G.GName,'')  GName
		   , COALESCE(u.Name,'') UserName
		   , COALESCE(u.Name_EN,'') UserNameEn
	FROM WorkingTime_LocationsOutside L
	LEFT JOIN WorkingTime_GroupPlace G ON L.GType = G.GNo
	LEFT JOIN Organization_Users U ON L.RegUserNo = U .UserNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
