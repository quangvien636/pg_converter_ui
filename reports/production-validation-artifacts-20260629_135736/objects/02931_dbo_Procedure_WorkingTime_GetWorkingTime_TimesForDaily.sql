-- ─── PROCEDURE→FUNCTION: workingtime_getworkingtime_timesfordaily ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_getworkingtime_timesfordaily(integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_getworkingtime_timesfordaily(
    IN userno integer,
    IN workingday integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF UserNo = 0 THEN

		RETURN QUERY
		SELECT WorkingNo, UserNo, TimeType, CheckTime,
			Provider, Latitude, Longitude, Remark
		FROM WorkingTime_Times
		WHERE WorkingDay = workingtime_getworkingtime_timesfordaily.workingday
	
	END IF;
	
	ELSE BEGIN
	
		RETURN QUERY
		SELECT WorkingNo, UserNo, TimeType, CheckTime,
		Provider, Latitude, Longitude, Remark
		FROM WorkingTime_Times 
		WHERE UserNo = workingtime_getworkingtime_timesfordaily.userno AND WorkingDay = workingtime_getworkingtime_timesfordaily.workingday
		and COALESCE(status,0) != 1
	
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
