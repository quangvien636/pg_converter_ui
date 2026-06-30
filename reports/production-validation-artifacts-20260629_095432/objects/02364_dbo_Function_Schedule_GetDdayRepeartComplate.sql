-- ─── FUNCTION: schedule_getddayrepeartcomplate ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getddayrepeartcomplate(timestamp without time zone);
CREATE OR REPLACE FUNCTION public.schedule_getddayrepeartcomplate(
    repeatdate timestamp without time zone
) RETURNS TABLE(
    ddayno text,
    repeatdate text,
    completedate text,
    iscomplete text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT DdayNo
      ,RepeatDate
      ,CompleteDate
      ,IsComplete
	FROM public."ScheduleDdaysRepeat"
	WHERE DdayNo = DdayNo AND RepeatDate = schedule_getddayrepeartcomplate.repeatdate AND IsComplete = 'Y';
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
