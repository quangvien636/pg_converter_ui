-- ─── FUNCTION: workingtime_locationdelete ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_locationdelete(integer);
CREATE OR REPLACE FUNCTION public.workingtime_locationdelete(
    locationno integer
) RETURNS void
AS $function$
BEGIN

   DELETE FROM WorkingTime_Locations
   WHERE LocationNo=workingtime_locationdelete.locationno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
