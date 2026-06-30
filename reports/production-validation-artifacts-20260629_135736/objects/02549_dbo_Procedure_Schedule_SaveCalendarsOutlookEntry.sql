-- ─── PROCEDURE→FUNCTION: schedule_savecalendarsoutlookentry ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_savecalendarsoutlookentry(character varying, character varying);
CREATE OR REPLACE FUNCTION public.schedule_savecalendarsoutlookentry(
    IN outlookentryid character varying,
    IN name character varying DEFAULT '내 일정(아웃룩)'
) RETURNS SETOF record
AS $function$
DECLARE
    calendarno integer;
    calendarcount integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	SELECT  INTO  FROM ScheduleCalendarsOutlook
	WHERE UserNo = UserNo
	AND OutlookEntryID = schedule_savecalendarsoutlookentry.outlookentryid
	
	IF CalendarCount = 0 THEN;
		INSERT INTO ScheduleCalendars (
		RegUserNo, RegDate, ModUserNo, ModDate, Name, Type, Color, UseLevel, Description,
		IsNotiNote, IsNotiMail, IsNotiSMS, IsNotiPopup, NotiTimeType, IsFixed)
		VALUES (UserNo, NOW(), UserNo, NOW(), Name, 2, '1e90ff', 0, '아웃룩 캘린더',
		0, 0, 0, 0, 0, 0)

		CalendarNo := lastval();;
		INSERT INTO ScheduleCalendarsOutlook
		(
			UserNo,
			CalendarNo,
			OutlookEntryID
		)
		VALUES
		(
			UserNo,
			CalendarNo,
			OutlookEntryID
		)
	END IF;
	ELSE
		SELECT  INTO  FROM ScheduleCalendarsOutlook
		WHERE UserNo = UserNo
		AND OutlookEntryID = schedule_savecalendarsoutlookentry.outlookentryid
		
		UPDATE ScheduleCalendars
		Name := schedule_savecalendarsoutlookentry.name,;
			ModDate = NOW(),
			ModUserNo = UserNo
		WHERE CalendarNo = CalendarNo
		
		UPDATE ScheduleCalendarsOutlook
		OutlookEntryID := schedule_savecalendarsoutlookentry.outlookentryid;
		WHERE UserNo = UserNo
		AND CalendarNo = CalendarNo
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
