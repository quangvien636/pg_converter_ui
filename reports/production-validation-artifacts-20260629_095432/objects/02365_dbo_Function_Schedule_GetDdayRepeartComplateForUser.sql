-- ─── FUNCTION: schedule_getddayrepeartcomplateforuser ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getddayrepeartcomplateforuser();
CREATE OR REPLACE FUNCTION public.schedule_getddayrepeartcomplateforuser(
) RETURNS TABLE(
    col1 text,
    repeatdate text,
    completedate text,
    iscomplete text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT /* TOP 1 */ DdayNo
      ,RepeatDate
      ,CompleteDate
      ,IsComplete
	FROM public."ScheduleDdaysRepeat"
	WHERE DdayNo = DdayNo AND IsComplete = 'Y';
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
