-- ─── PROCEDURE→FUNCTION: workingtime_accept_requestcorrectiontime ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.workingtime_accept_requestcorrectiontime(integer);
CREATE OR REPLACE FUNCTION public.workingtime_accept_requestcorrectiontime(
    IN workingno integer
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
