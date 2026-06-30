-- ─── PROCEDURE→FUNCTION: schedule_deletecalendar ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_deletecalendar(integer);
CREATE OR REPLACE FUNCTION public.schedule_deletecalendar(
    IN calendarno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



 from ScheduleContents where CalendarNo = schedule_deletecalendar.calendarno)

 if(pcount = 0)
		begin

			DELETE FROM ScheduleContentSharers WHERE ScheduleNo IN (SELECT ScheduleNo FROM ScheduleContents WHERE CalendarNo = schedule_deletecalendar.calendarno);
			DELETE FROM ScheduleContentsGoogle WHERE ScheduleNo IN (SELECT ScheduleNo FROM ScheduleContents WHERE CalendarNo = schedule_deletecalendar.calendarno);
			DELETE FROM ScheduleContents WHERE CalendarNo = schedule_deletecalendar.calendarno
	
			DELETE FROM ScheduleCalendarsGoogle WHERE CalendarNo = schedule_deletecalendar.calendarno;
			DELETE FROM ScheduleCalendars WHERE CalendarNo = schedule_deletecalendar.calendarno
	
			DELETE FROM ScheduleCalendarDefaultSharers WHERE CalendarNo = schedule_deletecalendar.calendarno;
			DELETE FROM ScheduleCalendarSharers WHERE CalendarNo = schedule_deletecalendar.calendarno;
			DELETE FROM ScheduleCalendarPermisions WHERE CalendarNo = schedule_deletecalendar.calendarno
			prs := 1;
		END;
	RETURN QUERY
	select prs;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
