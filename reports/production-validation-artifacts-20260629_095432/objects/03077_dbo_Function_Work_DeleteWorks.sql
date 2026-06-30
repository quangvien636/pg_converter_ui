-- ─── FUNCTION: work_deleteworks ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_deleteworks(character varying, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.work_deleteworks(
    worknos character varying,
    moduserno integer,
    moddate timestamp without time zone
) RETURNS void
-- TODO: LEN was not fully converted; use length()
AS $function$
DECLARE
    tbworknos table (
		workno int
	);
    tempstr character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN





	SET StartIndex = 1
	SET SearchIndex = 1

	WHILE (SearchIndex > 0)
	BEGIN

		SET SearchIndex = STRPOS(WorkNos, StartIndex, ';')

		IF SearchIndex = 0 BEGIN

			SET TempStr = RIGHT(WorkNos, LEN(WorkNos) - StartIndex + 1)

		END

		ELSE BEGIN

			SET TempStr = SUBSTRING(WorkNos, StartIndex, SearchIndex - StartIndex)

		END

		IF LEN(TempStr) > 0 BEGIN

			INSERT INTO tbWorkNos VALUES(TempStr)

		END

		SET StartIndex = SearchIndex + 1 

	END

	UPDATE Works SET Enabled = FALSE, ModUserNo = work_deleteworks.moduserno, ModDate = work_deleteworks.moddate
	WHERE WorkNo IN (SELECT WorkNo FROM tbWorkNos);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
