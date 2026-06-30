-- ─── FUNCTION: workingtime_employeevacation ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_employeevacation(timestamp without time zone, timestamp without time zone, integer);
CREATE OR REPLACE FUNCTION public.workingtime_employeevacation(
    p_from timestamp without time zone,
    p_to timestamp without time zone,
    p_uno integer
) RETURNS TABLE(
    reguserno text,
    contentdate text,
    timetype text,
    checktimefull text,
    remark text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT t.RegUserNo
			, CONVERT(varchar(10),t.CheckTimeFull,120) as ContentDate
			, t.TimeType
			, t.CheckTimeFull 
			, t.Remark
	FROM WorkingTime_Times t
	WHERE T.TimeType BETWEEN -6 and -1 AND T.CheckTimeFull BETWEEN p_from AND p_to AND T.RegUserNo = workingtime_employeevacation.p_uno
	ORDER BY T.CheckTimeFull asc;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
