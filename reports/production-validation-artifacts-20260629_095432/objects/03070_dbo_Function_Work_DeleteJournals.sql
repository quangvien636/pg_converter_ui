-- ─── FUNCTION: work_deletejournals ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_deletejournals();
CREATE OR REPLACE FUNCTION public.work_deletejournals(
) RETURNS TABLE(
    completionrate text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
-- TODO: LEN was not fully converted; use length()
AS $function$
DECLARE
    journalno integer;
    workno integer;
    tempstr character varying;
    completionrate integer;
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

			SET JournalNo = CONVERT(INT, TempStr)
			SET WorkNo = (SELECT WorkNo FROM WorkJournals WHERE JournalNo = JournalNo)

			DELETE FROM WorkJournals WHERE JournalNo = JournalNo
			

			RETURN QUERY
			SELECT /* TOP 1 */ CompletionRate = WJ.CompletionRate FROM WorkJournals WJ
			WHERE WJ.WorkNo = WorkNo AND WJ.CompletionRate <> -1
			ORDER BY WJ.CreationDate DESC, WJ.JournalNo DESC
			
			IF CompletionRate IS NOT NULL BEGIN
			
				IF CompletionRate = 100 BEGIN
				
					UPDATE Works SET CompletionRate = CompletionRate, FinalDate = NOW()
					WHERE WorkNo = WorkNo
					
				END
				
				ELSE BEGIN
				
					UPDATE Works SET CompletionRate = CompletionRate, FinalDate = NULL
					WHERE WorkNo = WorkNo
				
				END
				
			END
			
		END

		SET StartIndex = SearchIndex + 1 

	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
