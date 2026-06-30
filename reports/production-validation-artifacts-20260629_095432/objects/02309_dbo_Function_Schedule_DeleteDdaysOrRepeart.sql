-- ─── FUNCTION: schedule_deleteddaysorrepeart ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_deleteddaysorrepeart(timestamp without time zone);
CREATE OR REPLACE FUNCTION public.schedule_deleteddaysorrepeart(
    repeatdate timestamp without time zone
) RETURNS void
AS $function$
DECLARE
    userno integer;
BEGIN



	SELECT RepeatType = RepeatType, UserNo = RegUserNo FROM ScheduleDdays WHERE DdayNo = DdayNo;
	
	IF RepeatType = 0 
		BEGIN;
			DELETE FROM ScheduleDdays
				WHERE DdayNo = DdayNo;;
			DELETE FROM ScheduleDdaySharers WHERE DdayNo = DdayNo
		END
	ELSE
		BEGIN;
			DELETE FROM ScheduleDdaysRepeat
				WHERE DdayNo = DdayNo AND RepeatDate = schedule_deleteddaysorrepeart.repeatdate;
	END;
	INSERT INTO public."ScheduleDdaysHistory"
           (DdayNo
           ,HistoryType
           ,RegDate
           ,RegUserNo)
     VALUES
           (DdayNo
           ,'D'
           ,NOW()
           ,UserNo);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
