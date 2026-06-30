-- ─── FUNCTION: work_deleteregularjournals ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_deleteregularjournals();
CREATE OR REPLACE FUNCTION public.work_deleteregularjournals(
) RETURNS void
-- TODO: LEN was not fully converted; use length()
AS $function$
DECLARE
    tbjournalnos table (
		journalno int
	);
    tempstr character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN





	SET StartIndex = 1
	SET SearchIndex = 1

	WHILE (SearchIndex > 0)
	BEGIN

		SET SearchIndex = STRPOS(JournalNos, StartIndex, ';')

		IF SearchIndex = 0 BEGIN

			SET TempStr = RIGHT(JournalNos, LEN(JournalNos) - StartIndex + 1)

		END

		ELSE BEGIN

			SET TempStr = SUBSTRING(JournalNos, StartIndex, SearchIndex - StartIndex)

		END

		IF LEN(TempStr) > 0 BEGIN

			INSERT INTO tbJournalNos VALUES(TempStr)

		END

		SET StartIndex = SearchIndex + 1 

	END

	DELETE FROM RegularWorkJournals
	WHERE JournalNo IN (SELECT JournalNo FROM tbJournalNos);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
