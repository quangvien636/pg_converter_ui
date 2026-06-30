-- ─── PROCEDURE→FUNCTION: workingtime_get_status_requestcorrectiontime ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_get_status_requestcorrectiontime(integer);
CREATE OR REPLACE FUNCTION public.workingtime_get_status_requestcorrectiontime(
    IN workingno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT status FROM WorkingTime_RequestCorrectionTime WHERE WorkingNo = workingtime_get_status_requestcorrectiontime.workingno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
