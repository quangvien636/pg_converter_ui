-- ─── FUNCTION: workingtime_getworkingtimeworktimes ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getworkingtimeworktimes(integer);
CREATE OR REPLACE FUNCTION public.workingtime_getworkingtimeworktimes(
    locationno integer DEFAULT 0
) RETURNS SETOF record
-- TODO: replace SETOF record — add RETURNS TABLE(col1 type, col2 type, ...)
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT *
		FROM WorkingTime_WorkTime W
		Where LocationNo= workingtime_getworkingtimeworktimes.locationno
		ORDER BY WorkStart ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
