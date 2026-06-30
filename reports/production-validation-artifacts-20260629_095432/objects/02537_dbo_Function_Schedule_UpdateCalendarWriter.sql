-- ─── FUNCTION: schedule_updatecalendarwriter ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_updatecalendarwriter(integer, integer);
CREATE OR REPLACE FUNCTION public.schedule_updatecalendarwriter(
    p_calendarno integer,
    p_rno integer
) RETURNS void
AS $function$
BEGIN


	UPDATE ScheduleCalendars
	SET RegUserNo = schedule_updatecalendarwriter.p_rno
	WHERE CalendarNo = schedule_updatecalendarwriter.p_calendarno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
