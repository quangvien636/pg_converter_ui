-- ─── FUNCTION: workingtime_updatelocation_enabled ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_updatelocation_enabled(integer, boolean);
CREATE OR REPLACE FUNCTION public.workingtime_updatelocation_enabled(
    locationno integer,
    enabled boolean
) RETURNS void
AS $function$
BEGIN


	UPDATE WorkingTime_Locations SET Enabled = workingtime_updatelocation_enabled.enabled WHERE LocationNo = workingtime_updatelocation_enabled.locationno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
