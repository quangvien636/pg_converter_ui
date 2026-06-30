-- ─── FUNCTION: schedule_deletecalendarsharers ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_deletecalendarsharers(integer);
CREATE OR REPLACE FUNCTION public.schedule_deletecalendarsharers(
    calendarno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM ScheduleCalendarSharers WHERE CalendarNo = schedule_deletecalendarsharers.calendarno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
