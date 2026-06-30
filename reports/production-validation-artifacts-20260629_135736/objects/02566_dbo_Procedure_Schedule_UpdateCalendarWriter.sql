-- ─── PROCEDURE→FUNCTION: schedule_updatecalendarwriter ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_updatecalendarwriter(integer, integer);
CREATE OR REPLACE FUNCTION public.schedule_updatecalendarwriter(
    IN p_calendarno integer,
    IN p_rno integer
) RETURNS void
AS $function$
BEGIN


	UPDATE ScheduleCalendars
	RegUserNo := schedule_updatecalendarwriter.p_rno;
	WHERE CalendarNo = schedule_updatecalendarwriter.p_calendarno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
