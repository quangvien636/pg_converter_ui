-- ─── FUNCTION: workingtime_getweekday ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getweekday();
CREATE OR REPLACE FUNCTION public.workingtime_getweekday(
) RETURNS TABLE(
    id integer,
    sun integer,
    mon integer,
    tue integer,
    wen integer,
    thur integer,
    fri integer,
    sat integer
)
AS $function$
BEGIN

	
	RETURN QUERY
	SELECT * FROM WorkingTime_WeekDays d where d.Id = p_id;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
