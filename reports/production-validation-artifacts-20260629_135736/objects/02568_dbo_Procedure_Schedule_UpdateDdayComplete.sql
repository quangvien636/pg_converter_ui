-- ─── PROCEDURE→FUNCTION: schedule_updateddaycomplete ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_updateddaycomplete(timestamp without time zone);
CREATE OR REPLACE FUNCTION public.schedule_updateddaycomplete(
    IN repeatdate timestamp without time zone
) RETURNS void
AS $function$
BEGIN



	SELECT DisplayType, RepeatType INTO displaytype, repeattype FROM ScheduleDdays WHERE DdayNo = DdayNo;
	
	IF DisplayType = 'C' THEN
			IF RepeatType = 0 THEN;
				UPDATE ScheduleDdays
				CompleteDate := NOW(),;
					IsComplete = 'Y'
				WHERE DdayNo = DdayNo;
			END IF;
			ELSE;
				UPDATE ScheduleDdaysRepeat
				CompleteDate := NOW(),;
					IsComplete = ''
				WHERE DdayNo = DdayNo
				AND RepeatDate = schedule_updateddaycomplete.repeatdate;
			END IF;
		END IF;
		ELSIF DisplayType = 'D' THEN
			IF RepeatType <> 0 THEN;
					UPDATE ScheduleDdaysRepeat
					CompleteDate := NOW(),;
						IsComplete = 'Y'
					WHERE DdayNo = DdayNo AND RepeatDate = schedule_updateddaycomplete.repeatdate;
				END IF;
		END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
