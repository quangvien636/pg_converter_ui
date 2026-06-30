-- ─── FUNCTION: workingtime_updateworking ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_updateworking(integer, integer, integer, integer, timestamp without time zone, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_updateworking(
    p_no integer,
    p_time integer,
    p_day integer,
    p_check integer,
    p_timef timestamp without time zone,
    p_time2 integer,
    p_timefull integer,
    p_timefull2 integer
) RETURNS void
AS $function$
BEGIN

	UPDATE WorkingTime_Times
	SET TimeWorking   = workingtime_updateworking.p_time,
		WorkingDayC = workingtime_updateworking.p_day,
		CheckTimeC = workingtime_updateworking.p_check,
		CheckTimeFull = workingtime_updateworking.p_timef,
		TimeWorking2 = workingtime_updateworking.p_time2,
		TimeWorkingf = workingtime_updateworking.p_timefull,
		TimeWorkingf2 = workingtime_updateworking.p_timefull2
	WHERE WorkingNo= workingtime_updateworking.p_no;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
