-- ─── FUNCTION: schedule_deletecalendar ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_deletecalendar(integer);
CREATE OR REPLACE FUNCTION public.schedule_deletecalendar(
    calendarno integer
) RETURNS TABLE(
    scheduleno text
)
AS $function$
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
			set prs = 1
		end
	RETURN QUERY
	select prs;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
