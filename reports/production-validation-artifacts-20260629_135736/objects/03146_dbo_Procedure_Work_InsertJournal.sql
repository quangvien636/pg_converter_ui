-- ─── PROCEDURE→FUNCTION: work_insertjournal ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.work_insertjournal(integer, timestamp without time zone, integer, date, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.work_insertjournal(
    IN reguserno integer,
    IN regdate timestamp without time zone,
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


	INSERT INTO WorkJournals (RegUserNo, RegDate, ModUserNo, ModDate,
		WorkNo, CreationDate, DivisionNo, WorkTime, CompletionRate, Content)
	VALUES(RegUserNo, RegDate, RegUserNo, RegDate,
		WorkNo, CreationDate, DivisionNo, WorkTime, CompletionRate, Content)
		

	RETURN QUERY
	SELECT /* TOP 1 */ CompletionRate2 = WJ.CompletionRate FROM WorkJournals WJ
	WHERE WJ.WorkNo = work_insertjournal.workno AND WJ.CompletionRate <> -1
	ORDER BY WJ.CreationDate DESC, WJ.JournalNo DESC
	
	IF CompletionRate2 IS NOT NULL THEN
	
		IF CompletionRate2 = 100 THEN
		
			UPDATE Works SET CompletionRate = CompletionRate2, FinalDate = NOW()
			WHERE WorkNo = work_insertjournal.workno
			
		END IF;
		
		ELSE BEGIN
		
			UPDATE Works SET CompletionRate = CompletionRate2, FinalDate = NULL
			WHERE WorkNo = work_insertjournal.workno
		
		END IF;
		
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
