-- ─── PROCEDURE→FUNCTION: schedule_savecalendarsgoogle ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_savecalendarsgoogle(integer);
CREATE OR REPLACE FUNCTION public.schedule_savecalendarsgoogle(
    IN calendarno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	

	
	SELECT  INTO  FROM ScheduleCalendarsGoogle
	WHERE UserNo = UserNo
	AND CalendarNo = schedule_savecalendarsgoogle.calendarno
	
	IF CalendarCount = 0 THEN;
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
	END IF;
	ELSE;
		UPDATE ScheduleCalendarsGoogle
		GoogleCalendarID := GoogleCalendarID;
		WHERE UserNo = UserNo
		AND CalendarNo = schedule_savecalendarsgoogle.calendarno
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
