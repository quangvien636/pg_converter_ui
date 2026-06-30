-- ─── PROCEDURE→FUNCTION: schedule_savecalerndarsetupstartweek ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_savecalerndarsetupstartweek(integer);
CREATE OR REPLACE FUNCTION public.schedule_savecalerndarsetupstartweek(
    IN startweek integer
) RETURNS SETOF record
AS $function$
DECLARE
    intstartweek integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	SELECT StartWeek INTO intstartweek FROM ScheduleCalendarSetup WHERE UserNo = UserNo
	IF IntStartWeek = 1 OR IntStartWeek = 0 THEN;
			UPDATE ScheduleCalendarSetup
			StartWeek := schedule_savecalerndarsetupstartweek.startweek,;
				ModUserNo = UserNo,
				ModDate = NOW()
			WHERE UserNo = UserNo
		END IF;
	ELSE;
			INSERT INTO public."ScheduleCalendarSetup"
           (UserNo
           ,CalendarViewType
           ,StartWeek
           ,DefaultCalendarNo
           ,DivisionUseYN
           ,RegUserNo
           ,RegDate
           ,ModUserNo
           ,ModDate)
     VALUES
           (UserNo
           ,1
           ,StartWeek
           ,0
           ,'Y'
           ,UserNo
           ,NOW()
           ,UserNo
           ,NOW())
		END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
