-- ─── FUNCTION: workingtime_accept_requestcorrectiontime ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_accept_requestcorrectiontime(integer);
CREATE OR REPLACE FUNCTION public.workingtime_accept_requestcorrectiontime(
    workingno integer
) RETURNS void
AS $function$
BEGIN

	UPDATE WorkingTime_RequestCorrectionTime
		SET Status = 1
			,AccDate = AccDate
		WHERE WorkingNo = workingtime_accept_requestcorrectiontime.workingno;
	UPDATE WorkingTime_Calculater SET Status = 1 WHERE WorkingNoRef = workingtime_accept_requestcorrectiontime.workingno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
