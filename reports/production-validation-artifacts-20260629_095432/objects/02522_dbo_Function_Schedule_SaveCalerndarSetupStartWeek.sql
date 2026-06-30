-- ─── FUNCTION: schedule_savecalerndarsetupstartweek ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_savecalerndarsetupstartweek(integer);
CREATE OR REPLACE FUNCTION public.schedule_savecalerndarsetupstartweek(
    startweek integer
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    intstartweek integer;
BEGIN


	SELECT IntStartWeek = schedule_savecalerndarsetupstartweek.startweek FROM ScheduleCalendarSetup WHERE UserNo = UserNo
	IF IntStartWeek = 1 OR IntStartWeek = 0
		BEGIN;
			UPDATE ScheduleCalendarSetup
			SET
				StartWeek = schedule_savecalerndarsetupstartweek.startweek,
				ModUserNo = UserNo,
				ModDate = NOW()
			WHERE UserNo = UserNo
		END
	ELSE
		BEGIN;
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
		END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
