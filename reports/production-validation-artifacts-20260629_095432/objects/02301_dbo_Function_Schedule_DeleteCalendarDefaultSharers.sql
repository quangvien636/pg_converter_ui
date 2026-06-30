-- ─── FUNCTION: schedule_deletecalendardefaultsharers ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_deletecalendardefaultsharers(integer);
CREATE OR REPLACE FUNCTION public.schedule_deletecalendardefaultsharers(
    calendarno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM ScheduleCalendarDefaultSharers WHERE CalendarNo = schedule_deletecalendardefaultsharers.calendarno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
