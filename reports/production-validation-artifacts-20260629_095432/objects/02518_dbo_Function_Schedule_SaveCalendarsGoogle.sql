-- ─── FUNCTION: schedule_savecalendarsgoogle ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_savecalendarsgoogle(integer);
CREATE OR REPLACE FUNCTION public.schedule_savecalendarsgoogle(
    calendarno integer
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN

	

	
	SELECT CalendarCount = COUNT(CalendarNo) 
	FROM ScheduleCalendarsGoogle
	WHERE UserNo = UserNo
	AND CalendarNo = schedule_savecalendarsgoogle.calendarno
	
	IF CalendarCount = 0
	BEGIN;
		INSERT INTO ScheduleCalendarsGoogle
		(
			UserNo,
			CalendarNo,
			GoogleCalendarID
		)
		VALUES
		(
			UserNo,
			CalendarNo,
			GoogleCalendarID
		)
	END 
	ELSE
	BEGIN;
		UPDATE ScheduleCalendarsGoogle
		SET
			GoogleCalendarID =  GoogleCalendarID
		WHERE UserNo = UserNo
		AND CalendarNo = schedule_savecalendarsgoogle.calendarno
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
