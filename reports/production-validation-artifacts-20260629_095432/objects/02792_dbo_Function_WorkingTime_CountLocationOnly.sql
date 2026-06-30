-- ─── FUNCTION: workingtime_countlocationonly ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_countlocationonly();
CREATE OR REPLACE FUNCTION public.workingtime_countlocationonly(
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN

		RETURN QUERY
		SELECT COUNT(1) FROM WorkingTime_Locations;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
