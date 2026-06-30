-- ─── FUNCTION: workingtime_reject_requesttime ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_reject_requesttime(integer, datetimeoffset(7));
CREATE OR REPLACE FUNCTION public.workingtime_reject_requesttime(
    p_wk integer,
    p_date datetimeoffset(7)
) RETURNS void
AS $function$
BEGIN

	UPDATE WorkingTime_RequestCorrectionTime
		SET Reject = 1
			,RejectDate = workingtime_reject_requesttime.p_date
			,RejectDes = p_C
		WHERE WorkingNo = workingtime_reject_requesttime.p_wk;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
