-- ─── PROCEDURE→FUNCTION: schedule_deletecalendardefaultsharers ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_deletecalendardefaultsharers(integer);
CREATE OR REPLACE FUNCTION public.schedule_deletecalendardefaultsharers(
    IN calendarno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM ScheduleCalendarDefaultSharers WHERE CalendarNo = schedule_deletecalendardefaultsharers.calendarno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
