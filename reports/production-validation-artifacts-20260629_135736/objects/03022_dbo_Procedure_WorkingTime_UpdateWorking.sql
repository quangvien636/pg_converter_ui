-- ─── PROCEDURE→FUNCTION: workingtime_updateworking ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.workingtime_updateworking(integer, integer, integer, integer, timestamp without time zone, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_updateworking(
    IN p_no integer,
    IN p_time integer,
    IN p_day integer,
    IN p_check integer,
    IN p_timef timestamp without time zone,
    IN p_time2 integer,
    IN p_timefull integer,
    IN p_timefull2 integer
) RETURNS void
AS $function$
BEGIN

	UPDATE WorkingTime_Times
	TimeWorking := workingtime_updateworking.p_time,;
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
