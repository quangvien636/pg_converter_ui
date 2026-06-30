-- ─── PROCEDURE→FUNCTION: workingtime_updateweekday ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.workingtime_updateweekday(integer, integer, integer, integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_updateweekday(
    IN p_sun integer,
    IN p_mon integer,
    IN p_tue integer,
    IN p_wen integer,
    IN p_thur integer,
    IN p_fri integer,
    IN p_sat integer
) RETURNS void
AS $function$
BEGIN

	
	update WorkingTime_WeekDays 
	Sun := workingtime_updateweekday.p_sun;
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
