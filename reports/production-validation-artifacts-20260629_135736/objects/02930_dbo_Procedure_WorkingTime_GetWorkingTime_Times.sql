-- ─── PROCEDURE→FUNCTION: workingtime_getworkingtime_times ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_getworkingtime_times(integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_getworkingtime_times(
    IN userno integer,
    IN workingday integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT WorkingNo, TimeType, CheckTime, Provider, Latitude, Longitude, Remark
	FROM WorkingTime_Times W 
	WHERE W.UserNo = workingtime_getworkingtime_times.userno AND W.WorkingDay = workingtime_getworkingtime_times.workingday
	and COALESCE(w.status,0) != 1
	ORDER BY WorkingNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
