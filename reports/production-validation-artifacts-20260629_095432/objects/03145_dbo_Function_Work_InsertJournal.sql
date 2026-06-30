-- ─── FUNCTION: work_insertjournal ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_insertjournal(integer, timestamp without time zone, integer, date, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.work_insertjournal(
    reguserno integer,
    regdate timestamp without time zone,
    workno integer,
    creationdate date,
    divisionno integer,
    worktime integer,
    completionrate integer
) RETURNS TABLE(
    completionrate text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
DECLARE
    completionrate2 integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO WorkJournals (RegUserNo, RegDate, ModUserNo, ModDate,
		WorkNo, CreationDate, DivisionNo, WorkTime, CompletionRate, Content)
	VALUES(RegUserNo, RegDate, RegUserNo, RegDate,
		WorkNo, CreationDate, DivisionNo, WorkTime, CompletionRate, Content)
		

	RETURN QUERY
	SELECT /* TOP 1 */ CompletionRate2 = WJ.CompletionRate FROM WorkJournals WJ
	WHERE WJ.WorkNo = work_insertjournal.workno AND WJ.CompletionRate <> -1
	ORDER BY WJ.CreationDate DESC, WJ.JournalNo DESC
	
	IF CompletionRate2 IS NOT NULL BEGIN
	
		IF CompletionRate2 = 100 BEGIN
		
			UPDATE Works SET CompletionRate = CompletionRate2, FinalDate = NOW()
			WHERE WorkNo = work_insertjournal.workno
			
		END
		
		ELSE BEGIN
		
			UPDATE Works SET CompletionRate = CompletionRate2, FinalDate = NULL
			WHERE WorkNo = work_insertjournal.workno
		
		END
		
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
