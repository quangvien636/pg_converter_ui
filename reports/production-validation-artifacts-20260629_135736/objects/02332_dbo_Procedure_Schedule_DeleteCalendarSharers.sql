-- ─── PROCEDURE→FUNCTION: schedule_deletecalendarsharers ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_deletecalendarsharers(integer);
CREATE OR REPLACE FUNCTION public.schedule_deletecalendarsharers(
    IN calendarno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM ScheduleCalendarSharers WHERE CalendarNo = schedule_deletecalendarsharers.calendarno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
