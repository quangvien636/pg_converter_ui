-- ─── PROCEDURE→FUNCTION: schedule_inserttodosharers ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_inserttodosharers(integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.schedule_inserttodosharers(
    IN departno integer,
    IN userid character varying DEFAULT '',
    IN positionno integer DEFAULT 0
) RETURNS void
AS $function$
BEGIN

	IF DepartNo = 0 AND PositionNo = 0 THEN;
		INSERT INTO ScheduleToDoSharers(ToDoNo, UserNo, DepartNo, PositionNo)
		VALUES (ToDoNo, (SELECT UserNo FROM Organization_Users WHERE UserID = schedule_inserttodosharers.userid), 0, 0)
	END IF;
	ELSIF DepartNo > 0 AND PositionNo = 0 THEN;
		INSERT INTO ScheduleToDoSharers(ToDoNo, UserNo, DepartNo, PositionNo)
		VALUES (ToDoNo, 0, DepartNo, 0)
	END IF;
	ELSIF DepartNo = 0 AND PositionNo > 0 THEN;
		INSERT INTO ScheduleToDoSharers(ToDoNo, UserNo, DepartNo, PositionNo)
		VALUES (ToDoNo, 0, 0, PositionNo)
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
