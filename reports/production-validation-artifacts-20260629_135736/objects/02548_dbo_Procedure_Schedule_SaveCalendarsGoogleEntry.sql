-- ─── PROCEDURE→FUNCTION: schedule_savecalendarsgoogleentry ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_savecalendarsgoogleentry(character varying, character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.schedule_savecalendarsgoogleentry(
    IN googlecalendarid character varying,
    IN googlecalendaruri character varying,
    IN name character varying,
    IN color character varying,
    IN description character varying DEFAULT ''
) RETURNS SETOF record
AS $function$
DECLARE
    calendarno integer;
    calendarcount integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	SELECT  INTO  FROM ScheduleCalendarsGoogle
	WHERE UserNo = UserNo
	AND GoogleCalendarID = schedule_savecalendarsgoogleentry.googlecalendarid

	IF CalendarCount = 0 THEN
		
		INSERT INTO ScheduleCalendars (
		RegUserNo, RegDate, ModUserNo, ModDate, Name, Type, Color, UseLevel, Description,
		IsNotiNote, IsNotiMail, IsNotiSMS, IsNotiPopup, NotiTimeType, IsFixed)
		VALUES (UserNo, NOW(), UserNo, NOW(), Name, 2, Color, 0, Description,
		0, 0, 0, 0, 0, 0)

		CalendarNo := lastval();;
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
	END IF;
	ELSE
			
		SELECT  INTO  FROM ScheduleCalendarsGoogle
		WHERE UserNo = UserNo
		AND GoogleCalendarID = schedule_savecalendarsgoogleentry.googlecalendarid
	
	
		UPDATE ScheduleCalendars
		Name := schedule_savecalendarsgoogleentry.name,;
			Color = schedule_savecalendarsgoogleentry.color,
			Description = schedule_savecalendarsgoogleentry.description,
			ModDate = NOW(),
			ModUserNo = UserNo
		WHERE CalendarNo = CalendarNo
		
		UPDATE ScheduleCalendarsGoogle
		GoogleCalendarID := schedule_savecalendarsgoogleentry.googlecalendarid,;
			GoogleCalendarUri = schedule_savecalendarsgoogleentry.googlecalendaruri
		WHERE UserNo = UserNo
		AND CalendarNo = CalendarNo
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
