-- ─── FUNCTION: workingtime_deletebeaconpoint ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_deletebeaconpoint(integer);
CREATE OR REPLACE FUNCTION public.workingtime_deletebeaconpoint(
    pointno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM WorkingTime_BeaconPoints
	WHERE PointNo = workingtime_deletebeaconpoint.pointno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
