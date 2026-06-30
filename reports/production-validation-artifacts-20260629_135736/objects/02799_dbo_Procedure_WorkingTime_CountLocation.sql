-- ─── PROCEDURE→FUNCTION: workingtime_countlocation ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_countlocation();
CREATE OR REPLACE FUNCTION public.workingtime_countlocation(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT SUM (C1) AS C1 FROM
	(
		SELECT COUNT(1) AS C1 FROM WorkingTime_LocationsOutside 
		UNION ALL
		SELECT COUNT(1) FROM WorkingTime_Locations
	) AS T;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
