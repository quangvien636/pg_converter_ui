-- ─── FUNCTION: workingtime_updateweekday ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_updateweekday(integer, integer, integer, integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_updateweekday(
    p_sun integer,
    p_mon integer,
    p_tue integer,
    p_wen integer,
    p_thur integer,
    p_fri integer,
    p_sat integer
) RETURNS void
AS $function$
BEGIN

	
	update WorkingTime_WeekDays 
	set Sun = workingtime_updateweekday.p_sun
		,Mon = workingtime_updateweekday.p_mon
		,Tue = workingtime_updateweekday.p_tue
		,Wen = workingtime_updateweekday.p_wen
		,Thur = workingtime_updateweekday.p_thur
		,Fri = workingtime_updateweekday.p_fri
		,Sat = workingtime_updateweekday.p_sat
	 where Id = p_id;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
