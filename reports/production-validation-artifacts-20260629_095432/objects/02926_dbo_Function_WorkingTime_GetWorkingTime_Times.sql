-- ─── FUNCTION: workingtime_getworkingtime_times ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getworkingtime_times(integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_getworkingtime_times(
    userno integer,
    workingday integer
) RETURNS TABLE(
    workingno text,
    timetype text,
    checktime text,
    provider text,
    latitude text,
    longitude text,
    remark text
)
AS $function$
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
