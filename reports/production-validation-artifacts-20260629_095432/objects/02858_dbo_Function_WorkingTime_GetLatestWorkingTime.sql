-- ─── FUNCTION: workingtime_getlatestworkingtime ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getlatestworkingtime(integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_getlatestworkingtime(
    userno integer,
    workingday integer
) RETURNS TABLE(
    col1 text,
    timetype text,
    checktime text,
    provider text,
    latitude text,
    longitude text,
    remark text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
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
