-- ─── FUNCTION: schedule_updatetodosforiscomplete ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_updatetodosforiscomplete(character varying, integer, timestamp without time zone, boolean);
CREATE OR REPLACE FUNCTION public.schedule_updatetodosforiscomplete(
    todonos character varying,
    moduserno integer,
    moddate timestamp without time zone,
    iscomplete boolean
) RETURNS void
-- TODO: LEN was not fully converted; use length()
AS $function$
DECLARE
    tbtodonos table (
		todono int
	);
    tempstr character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN





	SET StartIndex = 1
	SET SearchIndex = 1

	WHILE (SearchIndex > 0)
	BEGIN

		SET SearchIndex = STRPOS(ToDoNos, StartIndex, ';')

		IF SearchIndex = 0 BEGIN

			SET TempStr = RIGHT(ToDoNos, LEN(ToDoNos) - StartIndex + 1)

		END

		ELSE BEGIN

			SET TempStr = SUBSTRING(ToDoNos, StartIndex, SearchIndex - StartIndex)

		END

		IF LEN(TempStr) > 0 BEGIN

			INSERT INTO tbToDoNos VALUES(TempStr)

		END

		SET StartIndex = SearchIndex + 1 

	END

	UPDATE ScheduleToDos SET
		CompleteDate = CASE WHEN IsComplete = TRUE THEN NOW() ELSE NULL END,
		ModUserNo = schedule_updatetodosforiscomplete.moduserno,
		ModDate = schedule_updatetodosforiscomplete.moddate,
		IsComplete = schedule_updatetodosforiscomplete.iscomplete
	WHERE ToDoNo IN (SELECT ToDoNo FROM tbToDoNos);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
