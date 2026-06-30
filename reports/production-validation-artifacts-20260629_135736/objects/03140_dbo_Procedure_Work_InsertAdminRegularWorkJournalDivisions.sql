-- ─── PROCEDURE→FUNCTION: work_insertadminregularworkjournaldivisions ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.work_insertadminregularworkjournaldivisions(integer, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.work_insertadminregularworkjournaldivisions(
    IN parentno integer,
    IN moduserno integer,
    IN moddate timestamp without time zone
) RETURNS SETOF record
AS $function$
DECLARE
    sortno integer;
    divisionno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	SortNo := (SELECT MAX(SortNo) FROM RegularWorkJournalDivisions WHERE ParentNo = work_insertadminregularworkjournaldivisions.parentno);
	IF SortNo IS NULL THEN
	
		SortNo := 1;
	END IF;
	
	ELSE BEGIN
	
		SortNo := SortNo + 1;
	END;

	INSERT INTO RegularWorkJournalDivisions (RegUserNo, RegDate, ModUserNo, ModDate, Name, SortNo,Enabled,ParentNo)
	VALUES (ModUserNo, ModDate, ModUserNo, ModDate,Name, SortNo, 1,ParentNo)
	

	DivisionNo := lastval();
	RETURN QUERY
	SELECT DivisionNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
