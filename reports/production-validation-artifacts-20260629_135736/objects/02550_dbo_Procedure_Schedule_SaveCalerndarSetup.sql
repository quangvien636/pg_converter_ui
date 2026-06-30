-- ─── PROCEDURE→FUNCTION: schedule_savecalerndarsetup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_savecalerndarsetup(integer, integer, integer, character varying, boolean, boolean);
CREATE OR REPLACE FUNCTION public.schedule_savecalerndarsetup(
    IN calendarviewtype integer,
    IN startweek integer,
    IN defaultcalendarno integer,
    IN divisionuseyn character varying DEFAULT 'Y',
    IN isfunctioncomplete boolean DEFAULT FALSE,
    IN p_12hours boolean DEFAULT FALSE
) RETURNS SETOF record
AS $function$
DECLARE
    nusercnt integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	SELECT COUNT(UserNo) INTO nusercnt FROM ScheduleCalendarSetup WHERE UserNo = UserNo
	
	IF nUserCnt = 0 THEN;
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
	END IF;
	ELSE;
		UPDATE ScheduleCalendarSetup
		CalendarViewType := schedule_savecalerndarsetup.calendarviewtype,;
			StartWeek = schedule_savecalerndarsetup.startweek,
			DefaultCalendarNo = schedule_savecalerndarsetup.defaultcalendarno,
			DivisionUseYN = schedule_savecalerndarsetup.divisionuseyn,
			IsFunctionComplete = schedule_savecalerndarsetup.isfunctioncomplete,
			ModUserNo = UserNo,
			ModDate = NOW(),
			is12hours = schedule_savecalerndarsetup.p_12hours
		WHERE UserNo = UserNo
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
