-- ─── FUNCTION: workingtime_dellbox ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_dellbox(integer);
CREATE OR REPLACE FUNCTION public.workingtime_dellbox(
    p_no integer
) RETURNS void
AS $function$
BEGIN


DELETE FROM WorkingTime_BoxUses WHERE NO = workingtime_dellbox.p_no;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
