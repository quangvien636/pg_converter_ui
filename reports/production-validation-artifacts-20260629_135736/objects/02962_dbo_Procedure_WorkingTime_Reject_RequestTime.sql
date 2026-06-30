-- ─── PROCEDURE→FUNCTION: workingtime_reject_requesttime ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.workingtime_reject_requesttime(integer, timestamp with time zone);
CREATE OR REPLACE FUNCTION public.workingtime_reject_requesttime(
    IN p_wk integer,
    IN p_date timestamp with time zone
) RETURNS void
AS $function$
BEGIN

	UPDATE WorkingTime_RequestCorrectionTime
		Reject := 1;
			,RejectDate = workingtime_reject_requesttime.p_date
			,RejectDes = p_C
		WHERE WorkingNo = workingtime_reject_requesttime.p_wk;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
