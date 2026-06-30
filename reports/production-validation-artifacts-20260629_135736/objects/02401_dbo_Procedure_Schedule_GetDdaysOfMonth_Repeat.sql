-- ─── PROCEDURE→FUNCTION: schedule_getddaysofmonth_repeat ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: DATEADD was not fully converted; use interval arithmetic
DROP FUNCTION IF EXISTS public.schedule_getddaysofmonth_repeat(integer, timestamp without time zone, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.schedule_getddaysofmonth_repeat(
    IN ddayno integer,
    IN startdate timestamp without time zone,
    IN enddate timestamp without time zone
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT DdayNo
      ,RepeatDate
      ,CompleteDate
      ,IsComplete
  FROM public."ScheduleDdaysRepeat"
  WHERE  DdayNo = schedule_getddaysofmonth_repeat.ddayno
  AND RepeatDate 
	BETWEEN CONVERT(CHAR(10), DATEADD(MONTH, DATEDIFF(MONTH, 0, StartDate), 0), 23) 
	AND CONVERT(CHAR(10), DATEADD(MONTH, DATEDIFF(MONTH, -1, EndDate), -1), 23);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
