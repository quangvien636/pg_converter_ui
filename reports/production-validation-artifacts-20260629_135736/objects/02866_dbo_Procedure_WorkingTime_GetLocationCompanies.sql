-- ─── PROCEDURE→FUNCTION: workingtime_getlocationcompanies ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_getlocationcompanies();
CREATE OR REPLACE FUNCTION public.workingtime_getlocationcompanies(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT LocationNo, RegUserNo, RegDate, ModUserNo, ModDate, Name, Latitude, Longitude, ErrorRange, Description, Enabled
	FROM WorkingTime_Locations 

	where COALESCE(uids,'') ='' and COALESCE(dids,'')='';
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
