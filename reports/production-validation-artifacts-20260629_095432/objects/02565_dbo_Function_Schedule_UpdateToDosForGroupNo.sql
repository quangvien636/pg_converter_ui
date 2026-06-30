-- ─── FUNCTION: schedule_updatetodosforgroupno ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_updatetodosforgroupno(character varying, integer, timestamp without time zone, integer);
CREATE OR REPLACE FUNCTION public.schedule_updatetodosforgroupno(
    todonos character varying,
    moduserno integer,
    moddate timestamp without time zone,
    groupno integer
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
		ModUserNo = schedule_updatetodosforgroupno.moduserno,
		ModDate = schedule_updatetodosforgroupno.moddate,
		GroupNo = schedule_updatetodosforgroupno.groupno
	WHERE ToDoNo IN (SELECT ToDoNo FROM tbToDoNos);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
