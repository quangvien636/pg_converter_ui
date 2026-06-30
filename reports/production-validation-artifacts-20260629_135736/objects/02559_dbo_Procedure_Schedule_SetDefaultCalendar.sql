-- ─── PROCEDURE→FUNCTION: schedule_setdefaultcalendar ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_setdefaultcalendar();
CREATE OR REPLACE FUNCTION public.schedule_setdefaultcalendar(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

    -- INSERT INTO statements for procedure here
	SELECT  INTO  FROM ScheduleCalendars
	WHERE Type = 2
	AND Name = '내 일정'
	AND RegUserNo = UserNo

	IF CalNo > 0 THEN
		SELECT COUNT(RegUserNo) INTO setupcnt FROM ScheduleCalendarSetup WHERE RegUserNo = UserNo
		IF SetupCnt = 0 THEN;
			INSERT INTO ScheduleCalendarSetup
			(CalendarViewType, StartWeek, DefaultCalendarNo, DivisionUseYN,
			RegUserNo, RegDate, ModUserNo, ModDate, IsFunctionComplete)
			VALUES
			( 1, 0, CalNo, 'Y',
			UserNo, NOW(), UserNo, NOW(), 0)
		END IF;
		ELSE;
			UPDATE ScheduleCalendarSetup 
			DefaultCalendarNo := CalNo;
				, ModUserNo = UserNo
				, ModDate = NOW()
			WHERE RegUserNo = UserNo
		END IF;

	END IF;

	RETURN QUERY
	SELECT COALESCE(CalNo,0) AS CalendarNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
