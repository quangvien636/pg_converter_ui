-- ─── FUNCTION: workingtime_getworkingtimes ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getworkingtimes(integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_getworkingtimes(
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
	WHERE W.UserNo = workingtime_getworkingtimes.userno AND W.WorkingDay = workingtime_getworkingtimes.workingday
	and COALESCE(w.status,0) != 1
	ORDER BY WorkingNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
