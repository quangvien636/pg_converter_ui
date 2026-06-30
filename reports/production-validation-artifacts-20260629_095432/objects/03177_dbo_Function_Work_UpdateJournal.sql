-- ─── FUNCTION: work_updatejournal ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_updatejournal(integer, integer, timestamp without time zone, integer, date, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.work_updatejournal(
    journalno integer,
    moduserno integer,
    moddate timestamp without time zone,
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


	UPDATE WorkJournals SET
		ModUserNo = work_updatejournal.moduserno,
		ModDate = work_updatejournal.moddate,
		CreationDate = work_updatejournal.creationdate,
		DivisionNo = work_updatejournal.divisionno,
		WorkTime = work_updatejournal.worktime,
		CompletionRate = work_updatejournal.completionrate,
		Content = Content
	WHERE JournalNo = work_updatejournal.journalno
		

	RETURN QUERY
	SELECT /* TOP 1 */ CompletionRate2 = WJ.CompletionRate FROM WorkJournals WJ
	WHERE WJ.WorkNo = work_updatejournal.workno AND WJ.CompletionRate <> -1
	ORDER BY WJ.CreationDate DESC, WJ.JournalNo DESC
	
	IF CompletionRate2 IS NOT NULL BEGIN
	
		IF CompletionRate2 = 100 BEGIN
		
			UPDATE Works SET CompletionRate = CompletionRate2, FinalDate = NOW()
			WHERE WorkNo = work_updatejournal.workno
			
		END
		
		ELSE BEGIN
		
			UPDATE Works SET CompletionRate = CompletionRate2, FinalDate = NULL
			WHERE WorkNo = work_updatejournal.workno
		
		END
		
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
