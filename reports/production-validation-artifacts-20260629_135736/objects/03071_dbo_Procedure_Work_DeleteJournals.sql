-- ─── PROCEDURE→FUNCTION: work_deletejournals ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
-- TODO: LEN was not fully converted; use length()
DROP FUNCTION IF EXISTS public.work_deletejournals();
CREATE OR REPLACE FUNCTION public.work_deletejournals(
) RETURNS SETOF record
AS $function$
DECLARE
    journalno integer;
    workno integer;
    tempstr character varying;
    completionrate integer;
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

			JournalNo := CONVERT(INT, TempStr);
			WorkNo := (SELECT WorkNo FROM WorkJournals WHERE JournalNo = JournalNo);;
			DELETE FROM WorkJournals WHERE JournalNo = JournalNo
			

			RETURN QUERY
			SELECT /* TOP 1 */ CompletionRate = WJ.CompletionRate FROM WorkJournals WJ
			WHERE WJ.WorkNo = WorkNo AND WJ.CompletionRate <> -1
			ORDER BY WJ.CreationDate DESC, WJ.JournalNo DESC
			
			IF CompletionRate IS NOT NULL THEN
			
				IF CompletionRate = 100 THEN
				
					UPDATE Works SET CompletionRate = CompletionRate, FinalDate = NOW()
					WHERE WorkNo = WorkNo
					
				END IF;
				
				ELSE BEGIN
				
					UPDATE Works SET CompletionRate = CompletionRate, FinalDate = NULL
					WHERE WorkNo = WorkNo
				
				END IF;
				
			END IF;
			
		END;

		StartIndex := SearchIndex + 1;
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
