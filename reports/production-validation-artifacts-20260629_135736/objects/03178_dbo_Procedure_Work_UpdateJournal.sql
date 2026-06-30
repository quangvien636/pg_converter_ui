-- ─── PROCEDURE→FUNCTION: work_updatejournal ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.work_updatejournal(integer, integer, timestamp without time zone, integer, date, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.work_updatejournal(
    IN journalno integer,
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN workno integer,
    IN creationdate date,
    IN divisionno integer,
    IN worktime integer,
    IN completionrate integer
) RETURNS SETOF record
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
	
	IF CompletionRate2 IS NOT NULL THEN
	
		IF CompletionRate2 = 100 THEN
		
			UPDATE Works SET CompletionRate = CompletionRate2, FinalDate = NOW()
			WHERE WorkNo = work_updatejournal.workno
			
		END IF;
		
		ELSE BEGIN
		
			UPDATE Works SET CompletionRate = CompletionRate2, FinalDate = NULL
			WHERE WorkNo = work_updatejournal.workno
		
		END IF;
		
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
