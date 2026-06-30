-- ─── FUNCTION: workingtime_getworkingtimesfordaily ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getworkingtimesfordaily(integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_getworkingtimesfordaily(
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
		WHERE WorkingDay = workingtime_getworkingtimesfordaily.workingday
		and COALESCE(status,0) != 1
	
	END
	
	ELSE BEGIN
	
		RETURN QUERY
		SELECT WorkingNo, UserNo, TimeType, CheckTime,
		Provider, Latitude, Longitude, Remark
		FROM WorkingTime_Times 
		WHERE UserNo = workingtime_getworkingtimesfordaily.userno AND WorkingDay = workingtime_getworkingtimesfordaily.workingday
		and COALESCE(status,0) != 1
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
