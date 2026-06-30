-- ─── FUNCTION: workingtime_getlaststatus ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getlaststatus(integer);
CREATE OR REPLACE FUNCTION public.workingtime_getlaststatus(
    userno integer
) RETURNS TABLE(
    max_date text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT WorkingNo
      ,RegUserNo
      ,RegDate
      ,UserNo
      ,WorkingDay
      ,TimeType
      ,CheckTime
      ,Provider
      ,Latitude
      ,Longitude
      ,Remark
      ,IpServer
      ,TimeCheckLong
      ,TimeOffset
      ,Distance
      ,LatCompany
      ,LngCompany
  FROM WorkingTime_Times
  where UserNo = workingtime_getlaststatus.userno 
		AND RegDate = (SELECT MAX(RegDate) as max_date FROM WorkingTime_Times WHERE UserNo = workingtime_getlaststatus.userno and Provider in (1,2,3,4,9,10) and COALESCE(status,0) != 1);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
