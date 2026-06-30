-- ─── FUNCTION: schedule_setdefaultcalendar ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_setdefaultcalendar();
CREATE OR REPLACE FUNCTION public.schedule_setdefaultcalendar(
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN



	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.


    -- INSERT INTO statements for procedure here
	SELECT CalNo = CalendarNo 
	FROM ScheduleCalendars
	WHERE Type = 2
	AND Name = '내 일정'
	AND RegUserNo = UserNo

	IF CalNo > 0
	BEGIN
		SELECT SetupCnt = COUNT(RegUserNo) FROM ScheduleCalendarSetup WHERE RegUserNo = UserNo
		IF SetupCnt = 0
		BEGIN;
			INSERT INTO ScheduleCalendarSetup
			(CalendarViewType, StartWeek, DefaultCalendarNo, DivisionUseYN,
			RegUserNo, RegDate, ModUserNo, ModDate, IsFunctionComplete)
			VALUES
			( 1, 0, CalNo, 'Y',
			UserNo, NOW(), UserNo, NOW(), 0)
		END
		ELSE
		BEGIN;
			UPDATE ScheduleCalendarSetup 
			SET
				DefaultCalendarNo = CalNo
				, ModUserNo = UserNo
				, ModDate = NOW()
			WHERE RegUserNo = UserNo
		END

	END

	RETURN QUERY
	SELECT COALESCE(CalNo,0) AS CalendarNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
