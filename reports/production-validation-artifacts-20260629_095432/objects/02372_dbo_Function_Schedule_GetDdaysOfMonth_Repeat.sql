-- ─── FUNCTION: schedule_getddaysofmonth_repeat ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getddaysofmonth_repeat(integer, timestamp without time zone, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.schedule_getddaysofmonth_repeat(
    ddayno integer,
    startdate timestamp without time zone,
    enddate timestamp without time zone
) RETURNS TABLE(
    ddayno text,
    repeatdate text,
    completedate text,
    iscomplete text
)
-- TODO: DATEADD was not fully converted; use interval arithmetic
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
