-- ─── PROCEDURE→FUNCTION: schedule_updatetodosforimportant ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: LEN was not fully converted; use length()
DROP FUNCTION IF EXISTS public.schedule_updatetodosforimportant(character varying, integer, timestamp without time zone, integer);
CREATE OR REPLACE FUNCTION public.schedule_updatetodosforimportant(
    IN todonos character varying,
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN important integer
) RETURNS void
AS $function$
DECLARE
    tbtodonos table (
		todono int
	);
    tempstr character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN





	StartIndex := 1;
	SearchIndex := 1;
	WHILE SearchIndex > 0 LOOP

		SearchIndex := STRPOS(ToDoNos, StartIndex, ';');
		IF SearchIndex = 0 THEN

			TempStr := RIGHT(ToDoNos, LEN(ToDoNos) - StartIndex + 1);
		END IF;

		ELSE BEGIN

			TempStr := SUBSTRING(ToDoNos, StartIndex, SearchIndex - StartIndex);
		END LOOP;

		IF LEN(TempStr) > 0 THEN

			INSERT INTO tbToDoNos VALUES(TempStr)

		END IF;

		StartIndex := SearchIndex + 1;
	END;

	UPDATE ScheduleToDos SET
		ModUserNo = schedule_updatetodosforimportant.moduserno,
		ModDate = schedule_updatetodosforimportant.moddate,
		Important = schedule_updatetodosforimportant.important
	WHERE ToDoNo IN (SELECT ToDoNo FROM tbToDoNos);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
