-- ─── FUNCTION: schedule_savecalendarsoutlookentry ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_savecalendarsoutlookentry(character varying, character varying);
CREATE OR REPLACE FUNCTION public.schedule_savecalendarsoutlookentry(
    outlookentryid character varying,
    name character varying DEFAULT '내 일정(아웃룩)'
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    calendarno integer;
    calendarcount integer;
BEGIN



	SELECT CalendarCount = COUNT(CalendarNo)
	FROM ScheduleCalendarsOutlook
	WHERE UserNo = UserNo
	AND OutlookEntryID = schedule_savecalendarsoutlookentry.outlookentryid
	
	IF CalendarCount = 0
	BEGIN;
		INSERT INTO ScheduleCalendars (
		RegUserNo, RegDate, ModUserNo, ModDate, Name, Type, Color, UseLevel, Description,
		IsNotiNote, IsNotiMail, IsNotiSMS, IsNotiPopup, NotiTimeType, IsFixed)
		VALUES (UserNo, NOW(), UserNo, NOW(), Name, 2, '1e90ff', 0, '아웃룩 캘린더',
		0, 0, 0, 0, 0, 0)

		SET CalendarNo = lastval()
		
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
	END
	ELSE
	BEGIN
		SELECT CalendarNo = CalendarNo
		FROM ScheduleCalendarsOutlook
		WHERE UserNo = UserNo
		AND OutlookEntryID = schedule_savecalendarsoutlookentry.outlookentryid
		
		UPDATE ScheduleCalendars
		SET
			Name = schedule_savecalendarsoutlookentry.name,
			ModDate = NOW(),
			ModUserNo = UserNo
		WHERE CalendarNo = CalendarNo
		
		UPDATE ScheduleCalendarsOutlook
		SET
			OutlookEntryID = schedule_savecalendarsoutlookentry.outlookentryid
		WHERE UserNo = UserNo
		AND CalendarNo = CalendarNo
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
