-- ─── FUNCTION: workingtime_workingtimebox ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_workingtimebox(integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_workingtimebox(
    p_wo integer,
    p_bno integer
) RETURNS void
AS $function$
BEGIN

UPDATE WorkingTime_Times
		SET bno=workingtime_workingtimebox.p_wo,
			bname=p_bname
		WHERE WorkingNo = workingtime_workingtimebox.p_wo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
