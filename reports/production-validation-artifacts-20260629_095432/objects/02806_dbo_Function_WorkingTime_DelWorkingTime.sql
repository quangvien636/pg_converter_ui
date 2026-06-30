-- ─── FUNCTION: workingtime_delworkingtime ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_delworkingtime(integer);
CREATE OR REPLACE FUNCTION public.workingtime_delworkingtime(
    workingno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM WorkingTime_Times WHERE WorkingNo = workingtime_delworkingtime.workingno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
