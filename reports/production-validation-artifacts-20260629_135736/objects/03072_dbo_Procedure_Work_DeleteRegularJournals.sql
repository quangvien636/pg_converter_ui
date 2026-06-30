-- ─── PROCEDURE→FUNCTION: work_deleteregularjournals ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: LEN was not fully converted; use length()
DROP FUNCTION IF EXISTS public.work_deleteregularjournals();
CREATE OR REPLACE FUNCTION public.work_deleteregularjournals(
) RETURNS void
AS $function$
DECLARE
    tbjournalnos table (
		journalno int
	);
    tempstr character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN





	StartIndex := 1;
	SearchIndex := 1;
	WHILE SearchIndex > 0 LOOP

		SearchIndex := STRPOS(JournalNos, StartIndex, ';');
		IF SearchIndex = 0 THEN

			TempStr := RIGHT(JournalNos, LEN(JournalNos) - StartIndex + 1);
		END IF;

		ELSE BEGIN

			TempStr := SUBSTRING(JournalNos, StartIndex, SearchIndex - StartIndex);
		END LOOP;

		IF LEN(TempStr) > 0 THEN

			INSERT INTO tbJournalNos VALUES(TempStr)

		END IF;

		StartIndex := SearchIndex + 1;
	END;

	DELETE FROM RegularWorkJournals
	WHERE JournalNo IN (SELECT JournalNo FROM tbJournalNos);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
