-- ─── FUNCTION: schedule_getddaysofmonth_newrepeat ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getddaysofmonth_newrepeat(timestamp without time zone);
CREATE OR REPLACE FUNCTION public.schedule_getddaysofmonth_newrepeat(
    curentdate timestamp without time zone
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
  WHERE  DdayNo = DdayNo AND RepeatDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, CurentDate), 0) AND RepeatDate <= DATEADD(MONTH, DATEDIFF(MONTH, -1, CurentDate), -1);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
