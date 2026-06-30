-- ─── PROCEDURE→FUNCTION: workingtime_getlatestworkingtime ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.workingtime_getlatestworkingtime(integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_getlatestworkingtime(
    IN userno integer,
    IN workingday integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT /* TOP 1 */ WorkingNo, TimeType, CheckTime, Provider, Latitude, Longitude, Remark
	FROM WorkingTime_Times W 
	WHERE UserNo = workingtime_getlatestworkingtime.userno AND WorkingDay = workingtime_getlatestworkingtime.workingday
	and COALESCE(w.status,0) != 1 
	ORDER BY WorkingNo DESC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
