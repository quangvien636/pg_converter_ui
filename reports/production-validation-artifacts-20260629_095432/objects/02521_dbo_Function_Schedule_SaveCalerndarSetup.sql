-- ─── FUNCTION: schedule_savecalerndarsetup ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_savecalerndarsetup(integer, integer, integer, character varying, boolean, boolean);
CREATE OR REPLACE FUNCTION public.schedule_savecalerndarsetup(
    calendarviewtype integer,
    startweek integer,
    defaultcalendarno integer,
    divisionuseyn character varying DEFAULT 'Y',
    isfunctioncomplete boolean DEFAULT FALSE,
    p_12hours boolean DEFAULT FALSE
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    nusercnt integer;
BEGIN


	SELECT nUserCnt = COUNT(UserNo) FROM ScheduleCalendarSetup WHERE UserNo = UserNo
	
	IF nUserCnt = 0
	BEGIN;
		INSERT INTO ScheduleCalendarSetup 
		(
			UserNo,
			CalendarViewType,
			StartWeek,
			DefaultCalendarNo,
			DivisionUseYN,
			IsFunctionComplete,
			RegUserNo,
			RegDate,
			ModUserNo,
			ModDate,
			is12hours
		)
		VALUES
		(
			UserNo,
			CalendarViewType,
			StartWeek,
			DefaultCalendarNo,
			DivisionUseYN,
			IsFunctionComplete,
			UserNo,			
			NOW(),
			UserNo,
			NOW(),
			p_12hours
		)
	END 
	ELSE
	BEGIN;
		UPDATE ScheduleCalendarSetup
		SET
			CalendarViewType = schedule_savecalerndarsetup.calendarviewtype,
			StartWeek = schedule_savecalerndarsetup.startweek,
			DefaultCalendarNo = schedule_savecalerndarsetup.defaultcalendarno,
			DivisionUseYN = schedule_savecalerndarsetup.divisionuseyn,
			IsFunctionComplete = schedule_savecalerndarsetup.isfunctioncomplete,
			ModUserNo = UserNo,
			ModDate = NOW(),
			is12hours = schedule_savecalerndarsetup.p_12hours
		WHERE UserNo = UserNo
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
