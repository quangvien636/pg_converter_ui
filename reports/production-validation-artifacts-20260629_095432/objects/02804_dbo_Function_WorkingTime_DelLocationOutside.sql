-- ─── FUNCTION: workingtime_dellocationoutside ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_dellocationoutside(integer);
CREATE OR REPLACE FUNCTION public.workingtime_dellocationoutside(
    locationno integer
) RETURNS void
AS $function$
BEGIN

	DELETE FROM WorkingTime_LocationsOutside
	WHERE LocationNo = workingtime_dellocationoutside.locationno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
