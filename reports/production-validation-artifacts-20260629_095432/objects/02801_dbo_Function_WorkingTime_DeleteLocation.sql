-- ─── FUNCTION: workingtime_deletelocation ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_deletelocation();
CREATE OR REPLACE FUNCTION public.workingtime_deletelocation(
) RETURNS void
AS $function$
BEGIN

	DELETE FROM WorkingTime_Locations
	WHERE LocationNo = LocationNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
