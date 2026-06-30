-- ─── PROCEDURE→FUNCTION: workingtime_reportsoutsidetotal ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_reportsoutsidetotal(integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_reportsoutsidetotal(
    IN p_from integer,
    IN p_to integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT COUNT(S.LocationNo) Total
		,COUNT(W.TotalVisited) Visited
		,COALESCE(SUM(CASE WHEN COALESCE(W.LocationNo,0) = 0 THEN 1 ELSE 0 END),0) UnVisited
	FROM WorkingTime_LocationsOutside S
	LEFT JOIN 
	(
		SELECT LocationNo,COUNT(1) TotalVisited 
		FROM WorkingTime_Times 
		WHERE TimeType = 2  AND WorkingDay BETWEEN p_From AND p_To
		and COALESCE(status,0) != 1
		GROUP BY LocationNo
	) W ON S.LocationNo = W.LocationNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
