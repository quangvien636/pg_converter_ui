-- ─── FUNCTION: workingtime_sumlocations ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_sumlocations();
CREATE OR REPLACE FUNCTION public.workingtime_sumlocations(
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN


RETURN QUERY
SELECT (SELECT Count(1) FROM WorkingTime_Locations) + (SELECT Count(1) FROM WorkingTime_LocationsOutside ) AS TOTAL
		,(SELECT Count(1) FROM WorkingTime_Locations) Location
		,(SELECT Count(1) FROM WorkingTime_LocationsOutside ) LocationOutside;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
