-- ─── FUNCTION: schedule_updateddaycomplete_ ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_updateddaycomplete_(timestamp without time zone, date, character varying);
CREATE OR REPLACE FUNCTION public.schedule_updateddaycomplete_(
    repeatdate timestamp without time zone,
    completedate date DEFAULT 'GETDATE',
    iscomplete character varying DEFAULT 'N'
) RETURNS TABLE(
    ddayno text
)
AS $function$
BEGIN




	SELECT DisplayType = DisplayType, RepeatType = RepeatType FROM ScheduleDdays WHERE DdayNo = DdayNo;
	
	IF IsComplete ='A'
		BEGIN;
			UPDATE ScheduleDdays
				SET
					CompleteDate =schedule_updateddaycomplete_.completedate,
					IsComplete = 'D'
				WHERE DdayNo = DdayNo;
		END
	ELSE
		BEGIN
			IF DisplayType = 'C' 
				BEGIN
			IF RepeatType = 0 
			BEGIN;
				UPDATE ScheduleDdays
				SET
					CompleteDate = schedule_updateddaycomplete_.completedate,
					IsComplete = schedule_updateddaycomplete_.iscomplete
				WHERE DdayNo = DdayNo;
			END
			ELSE
			BEGIN
				SELECT RepeatNo = ScheduleDdaysRepeat.DdayNo FROM ScheduleDdaysRepeat WHERE ScheduleDdaysRepeat.DdayNo = DdayNo AND ScheduleDdaysRepeat.RepeatDate = schedule_updateddaycomplete_.repeatdate;
				IF RepeatNo = 0
					BEGIN;
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
						
					END
				ELSE
					BEGIN;
						UPDATE ScheduleDdaysRepeat
						SET
							CompleteDate = schedule_updateddaycomplete_.completedate,
							IsComplete = schedule_updateddaycomplete_.iscomplete
						WHERE DdayNo = DdayNo
						AND RepeatDate = schedule_updateddaycomplete_.repeatdate;
					END
			END
		END
			ELSE IF DisplayType = 'D' 
				BEGIN
			IF RepeatType <> 0 
				BEGIN
				SELECT RepeatNo = ScheduleDdaysRepeat.DdayNo FROM ScheduleDdaysRepeat WHERE ScheduleDdaysRepeat.DdayNo = DdayNo AND ScheduleDdaysRepeat.RepeatDate = schedule_updateddaycomplete_.repeatdate;
					IF RepeatNo = 0
						BEGIN;
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
						END
					ELSE
					BEGIN;
						UPDATE ScheduleDdaysRepeat
						SET
							CompleteDate = schedule_updateddaycomplete_.completedate,
							IsComplete = schedule_updateddaycomplete_.iscomplete
						WHERE DdayNo = DdayNo AND RepeatDate = schedule_updateddaycomplete_.repeatdate;
					END
				END
			ELSE
			BEGIN;
				UPDATE ScheduleDdays
				SET
					CompleteDate =schedule_updateddaycomplete_.completedate,
					IsComplete = schedule_updateddaycomplete_.iscomplete
				WHERE DdayNo = DdayNo;
			END
		END
		END
	IF IsComplete = 'Y'
	BEGIN;
		UPDATE ScheduleDdays
		SET
			CompleteDate = schedule_updateddaycomplete_.repeatdate
		WHERE DdayNo = DdayNo;
	END;
	DELETE FROM ScheduleDdaysRepeat WHERE DdayNo IN (SELECT DdayNo FROM ScheduleDdays WHERE IsComplete = 'D');
	DELETE FROM ScheduleDdays WHERE ScheduleDdays.IsComplete = 'D';
	DELETE FROM ScheduleDdaysRepeat WHERE DdayNo NOT IN (SELECT DdayNo FROM ScheduleDdays);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
