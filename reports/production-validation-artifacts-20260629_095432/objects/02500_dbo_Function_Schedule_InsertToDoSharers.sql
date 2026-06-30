-- ─── FUNCTION: schedule_inserttodosharers ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_inserttodosharers(integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.schedule_inserttodosharers(
    departno integer,
    userid character varying DEFAULT '',
    positionno integer DEFAULT 0
) RETURNS void
AS $function$
BEGIN

	IF DepartNo = 0 AND PositionNo = 0
	BEGIN;
		INSERT INTO ScheduleToDoSharers(ToDoNo, UserNo, DepartNo, PositionNo)
		VALUES (ToDoNo, (SELECT UserNo FROM Organization_Users WHERE UserID = schedule_inserttodosharers.userid), 0, 0)
	END
	ELSE IF DepartNo > 0 AND PositionNo = 0 
	BEGIN;
		INSERT INTO ScheduleToDoSharers(ToDoNo, UserNo, DepartNo, PositionNo)
		VALUES (ToDoNo, 0, DepartNo, 0)
	END
	ELSE IF DepartNo = 0 AND PositionNo > 0
	BEGIN;
		INSERT INTO ScheduleToDoSharers(ToDoNo, UserNo, DepartNo, PositionNo)
		VALUES (ToDoNo, 0, 0, PositionNo)
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
