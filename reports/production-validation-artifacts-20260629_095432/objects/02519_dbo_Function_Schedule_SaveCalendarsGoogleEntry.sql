-- ─── FUNCTION: schedule_savecalendarsgoogleentry ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_savecalendarsgoogleentry(character varying, character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.schedule_savecalendarsgoogleentry(
    googlecalendarid character varying,
    googlecalendaruri character varying,
    name character varying,
    color character varying,
    description character varying DEFAULT ''
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    calendarno integer;
    calendarcount integer;
BEGIN



	SELECT CalendarCount = COUNT(CalendarNo) 
	FROM ScheduleCalendarsGoogle
	WHERE UserNo = UserNo
	AND GoogleCalendarID = schedule_savecalendarsgoogleentry.googlecalendarid

	IF CalendarCount = 0
	BEGIN
		
		INSERT INTO ScheduleCalendars (
		RegUserNo, RegDate, ModUserNo, ModDate, Name, Type, Color, UseLevel, Description,
		IsNotiNote, IsNotiMail, IsNotiSMS, IsNotiPopup, NotiTimeType, IsFixed)
		VALUES (UserNo, NOW(), UserNo, NOW(), Name, 2, Color, 0, Description,
		0, 0, 0, 0, 0, 0)

		SET CalendarNo = lastval()

		INSERT INTO ScheduleCalendarsGoogle
		(
			UserNo,
			CalendarNo,
			GoogleCalendarID,
			GoogleCalendarUri
		)
		VALUES
		(
			UserNo,
			CalendarNo,
			GoogleCalendarID,
			GoogleCalendarUri
		)
	END 
	ELSE
	BEGIN
			
		SELECT CalendarNo = CalendarNo
		FROM ScheduleCalendarsGoogle
		WHERE UserNo = UserNo
		AND GoogleCalendarID = schedule_savecalendarsgoogleentry.googlecalendarid
	
	
		UPDATE ScheduleCalendars
		SET
			Name = schedule_savecalendarsgoogleentry.name,
			Color = schedule_savecalendarsgoogleentry.color,
			Description = schedule_savecalendarsgoogleentry.description,
			ModDate = NOW(),
			ModUserNo = UserNo
		WHERE CalendarNo = CalendarNo
		
		UPDATE ScheduleCalendarsGoogle
		SET
			GoogleCalendarID =  schedule_savecalendarsgoogleentry.googlecalendarid,
			GoogleCalendarUri = schedule_savecalendarsgoogleentry.googlecalendaruri
		WHERE UserNo = UserNo
		AND CalendarNo = CalendarNo
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
