-- ─── PROCEDURE→FUNCTION: schedule_deleteddaysorrepeart ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_deleteddaysorrepeart(timestamp without time zone);
CREATE OR REPLACE FUNCTION public.schedule_deleteddaysorrepeart(
    IN repeatdate timestamp without time zone
) RETURNS void
AS $function$
DECLARE
    userno integer;
BEGIN



	SELECT RepeatType, RegUserNo INTO repeattype, userno FROM ScheduleDdays WHERE DdayNo = DdayNo;
	
	IF RepeatType = 0 THEN;
			DELETE FROM ScheduleDdays
				WHERE DdayNo = DdayNo;;
			DELETE FROM ScheduleDdaySharers WHERE DdayNo = DdayNo
		END IF;
	ELSE;
			DELETE FROM ScheduleDdaysRepeat
				WHERE DdayNo = DdayNo AND RepeatDate = schedule_deleteddaysorrepeart.repeatdate;
	END IF;;
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
