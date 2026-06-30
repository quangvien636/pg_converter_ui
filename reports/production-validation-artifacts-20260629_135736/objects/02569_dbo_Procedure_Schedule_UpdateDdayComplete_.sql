-- ─── PROCEDURE→FUNCTION: schedule_updateddaycomplete_ ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_updateddaycomplete_(timestamp without time zone, date, character varying);
CREATE OR REPLACE FUNCTION public.schedule_updateddaycomplete_(
    IN repeatdate timestamp without time zone,
    IN completedate date DEFAULT 'GETDATE',
    IN iscomplete character varying DEFAULT 'N'
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN




	SELECT DisplayType, RepeatType INTO displaytype, repeattype FROM ScheduleDdays WHERE DdayNo = DdayNo;
	
	IF IsComplete ='A' THEN;
			UPDATE ScheduleDdays
				CompleteDate := schedule_updateddaycomplete_.completedate,;
					IsComplete = 'D'
				WHERE DdayNo = DdayNo;
		END IF;
	ELSE
			IF DisplayType = 'C' THEN
			IF RepeatType = 0 THEN;
				UPDATE ScheduleDdays
				CompleteDate := schedule_updateddaycomplete_.completedate,;
					IsComplete = schedule_updateddaycomplete_.iscomplete
				WHERE DdayNo = DdayNo;
			END IF;
			ELSE
				SELECT ScheduleDdaysRepeat.DdayNo INTO repeatno FROM ScheduleDdaysRepeat WHERE ScheduleDdaysRepeat.DdayNo = DdayNo AND ScheduleDdaysRepeat.RepeatDate = schedule_updateddaycomplete_.repeatdate;
				IF RepeatNo = 0 THEN;
						INSERT INTO ScheduleDdaysRepeat
								   (DdayNo
								   ,RepeatDate
								   ,CompleteDate
								   ,IsComplete)
							 VALUES
								   (DdayNo
								   ,RepeatDate
								   ,CompleteDate
								   ,IsComplete)
						
					END IF;
				ELSE;
						UPDATE ScheduleDdaysRepeat
						CompleteDate := schedule_updateddaycomplete_.completedate,;
							IsComplete = schedule_updateddaycomplete_.iscomplete
						WHERE DdayNo = DdayNo
						AND RepeatDate = schedule_updateddaycomplete_.repeatdate;
					END IF;
			END IF;
		END IF;
			ELSIF DisplayType = 'D' THEN
			IF RepeatType <> 0 THEN
				SELECT ScheduleDdaysRepeat.DdayNo INTO repeatno FROM ScheduleDdaysRepeat WHERE ScheduleDdaysRepeat.DdayNo = DdayNo AND ScheduleDdaysRepeat.RepeatDate = schedule_updateddaycomplete_.repeatdate;
					IF RepeatNo = 0 THEN;
							INSERT INTO ScheduleDdaysRepeat
									   (DdayNo
									   ,RepeatDate
									   ,CompleteDate
									   ,IsComplete)
								 VALUES
									   (DdayNo
									   ,RepeatDate
									   ,CompleteDate
									   ,IsComplete)
						END IF;
					ELSE;
						UPDATE ScheduleDdaysRepeat
						CompleteDate := schedule_updateddaycomplete_.completedate,;
							IsComplete = schedule_updateddaycomplete_.iscomplete
						WHERE DdayNo = DdayNo AND RepeatDate = schedule_updateddaycomplete_.repeatdate;
					END IF;
				END IF;
			ELSE;
				UPDATE ScheduleDdays
				CompleteDate := schedule_updateddaycomplete_.completedate,;
					IsComplete = schedule_updateddaycomplete_.iscomplete
				WHERE DdayNo = DdayNo;
			END IF;
		END IF;
		END IF;
	IF IsComplete = 'Y' THEN;
		UPDATE ScheduleDdays
		CompleteDate := schedule_updateddaycomplete_.repeatdate;
		WHERE DdayNo = DdayNo;
	END IF;;
	DELETE FROM ScheduleDdaysRepeat WHERE DdayNo IN (SELECT DdayNo FROM ScheduleDdays WHERE IsComplete = 'D');
	DELETE FROM ScheduleDdays WHERE ScheduleDdays.IsComplete = 'D';
	DELETE FROM ScheduleDdaysRepeat WHERE DdayNo NOT IN (SELECT DdayNo FROM ScheduleDdays);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
