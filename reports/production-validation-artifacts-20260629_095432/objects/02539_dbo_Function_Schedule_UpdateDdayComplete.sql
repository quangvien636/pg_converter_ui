-- ─── FUNCTION: schedule_updateddaycomplete ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_updateddaycomplete(timestamp without time zone);
CREATE OR REPLACE FUNCTION public.schedule_updateddaycomplete(
    repeatdate timestamp without time zone
) RETURNS void
AS $function$
BEGIN



	SELECT DisplayType = DisplayType, RepeatType = RepeatType FROM ScheduleDdays WHERE DdayNo = DdayNo;
	
	IF DisplayType = 'C' 
		BEGIN
			IF RepeatType = 0 
			BEGIN;
				UPDATE ScheduleDdays
				SET
					CompleteDate = NOW(),
					IsComplete = 'Y'
				WHERE DdayNo = DdayNo;
			END
			ELSE
			BEGIN;
				UPDATE ScheduleDdaysRepeat
				SET
					CompleteDate = NOW(),
					IsComplete = ''
				WHERE DdayNo = DdayNo
				AND RepeatDate = schedule_updateddaycomplete.repeatdate;
			END
		END
		ELSE IF DisplayType = 'D' 
		BEGIN
			IF RepeatType <> 0 
				BEGIN;
					UPDATE ScheduleDdaysRepeat
					SET
						CompleteDate = NOW(),
						IsComplete = 'Y'
					WHERE DdayNo = DdayNo AND RepeatDate = schedule_updateddaycomplete.repeatdate;
				END
		END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
