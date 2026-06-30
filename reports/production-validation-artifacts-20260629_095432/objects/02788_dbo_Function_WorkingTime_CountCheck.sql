-- ─── FUNCTION: workingtime_countcheck ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_countcheck(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_countcheck(
    p_uno integer,
    p_day integer,
    p_type integer
) RETURNS TABLE(
    checkcount text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT COUNT(1) AS CheckCount FROM WorkingTime_Times w
	WHERE w.UserNo = workingtime_countcheck.p_uno AND W.WorkingDayC = workingtime_countcheck.p_day and (w.TimeType = workingtime_countcheck.p_type or w.TimeType < 0);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
