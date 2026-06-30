-- ─── FUNCTION: workingtime_countlocation ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_countlocation();
CREATE OR REPLACE FUNCTION public.workingtime_countlocation(
) RETURNS TABLE(
    col1 text
)
AS $function$
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
