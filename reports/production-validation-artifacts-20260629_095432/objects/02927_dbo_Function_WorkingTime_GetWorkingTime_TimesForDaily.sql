-- ─── FUNCTION: workingtime_getworkingtime_timesfordaily ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getworkingtime_timesfordaily(integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_getworkingtime_timesfordaily(
    userno integer,
    workingday integer
) RETURNS TABLE(
    workingno text,
    userno text,
    timetype text,
    checktime text,
    provider text,
    latitude text,
    longitude text,
    remark text
)
AS $function$
BEGIN


	IF UserNo = 0 BEGIN

		RETURN QUERY
		SELECT WorkingNo, UserNo, TimeType, CheckTime,
			Provider, Latitude, Longitude, Remark
		FROM WorkingTime_Times
		WHERE WorkingDay = workingtime_getworkingtime_timesfordaily.workingday
	
	END
	
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
