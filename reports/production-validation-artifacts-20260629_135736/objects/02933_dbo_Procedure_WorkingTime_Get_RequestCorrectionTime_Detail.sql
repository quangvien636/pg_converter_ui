-- ─── PROCEDURE→FUNCTION: workingtime_get_requestcorrectiontime_detail ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_get_requestcorrectiontime_detail(character varying, character varying);
CREATE OR REPLACE FUNCTION public.workingtime_get_requestcorrectiontime_detail(
    IN fromdate character varying DEFAULT '20160601',
    IN todate character varying DEFAULT '20160631'
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT t.UserNo,t.WorkingNo,t.Remark,t2.CheckDateTimeOffset,t2.WorkingDayOfCompany,r.RegDate,r.AccDate,r.Status
		FROM WorkingTime_RequestCorrectionTime r
			INNER JOIN WorkingTime_Times t ON r.WorkingNo = t.WorkingNo
			INNER JOIN WorkingTime_Times_v2 t2 ON r.WorkingNo = t2.WorkingNo
		WHERE t2.WorkingDayOfCompany BETWEEN FromDate AND ToDate;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
