-- ─── FUNCTION: workingtime_reportsoutsidetotal ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_reportsoutsidetotal(integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_reportsoutsidetotal(
    p_from integer,
    p_to integer
) RETURNS TABLE(
    locationno text,
    col2 text
)
AS $function$
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
