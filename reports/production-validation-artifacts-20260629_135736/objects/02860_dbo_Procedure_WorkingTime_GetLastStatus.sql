-- ─── PROCEDURE→FUNCTION: workingtime_getlaststatus ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_getlaststatus(integer);
CREATE OR REPLACE FUNCTION public.workingtime_getlaststatus(
    IN userno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
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
