-- ─── PROCEDURE→FUNCTION: workingtime_get_totalpage_requestcorrectiontime ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_get_totalpage_requestcorrectiontime(character varying);
CREATE OR REPLACE FUNCTION public.workingtime_get_totalpage_requestcorrectiontime(
    IN fromdate character varying
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	
		RETURN QUERY
		SELECT  COUNT(*) AS totalPage

			FROM WorkingTime_Times t INNER JOIN WorkingTime_Times_v2 t2 ON t.WorkingNo = t2.WorkingNo
									 INNER JOIN WorkingTime_RequestCorrectionTime r ON t.WorkingNo = r.WorkingNo

			WHERE t2.WorkingDayOfCompany BETWEEN  FromDate AND ToDate
					AND (t.Provider = 999);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
