-- ─── FUNCTION: workingtime_get_status_requestcorrectiontime ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_get_status_requestcorrectiontime(integer);
CREATE OR REPLACE FUNCTION public.workingtime_get_status_requestcorrectiontime(
    workingno integer
) RETURNS TABLE(
    status text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT status FROM WorkingTime_RequestCorrectionTime WHERE WorkingNo = workingtime_get_status_requestcorrectiontime.workingno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
