-- ─── PROCEDURE→FUNCTION: workingtime_getofficeuser ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_getofficeuser(integer);
CREATE OR REPLACE FUNCTION public.workingtime_getofficeuser(
    IN userno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
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
