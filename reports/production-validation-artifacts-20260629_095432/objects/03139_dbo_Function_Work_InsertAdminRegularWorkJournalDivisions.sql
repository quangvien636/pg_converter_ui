-- ─── FUNCTION: work_insertadminregularworkjournaldivisions ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_insertadminregularworkjournaldivisions(integer, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.work_insertadminregularworkjournaldivisions(
    parentno integer,
    moduserno integer,
    moddate timestamp without time zone
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    sortno integer;
    divisionno integer;
BEGIN



	SET SortNo = (SELECT MAX(SortNo) FROM RegularWorkJournalDivisions WHERE ParentNo = work_insertadminregularworkjournaldivisions.parentno)
	
	IF (SortNo IS NULL) BEGIN
	
		SET SortNo = 1
	
	END
	
	ELSE BEGIN
	
		SET SortNo = SortNo + 1
	
	END

	INSERT INTO RegularWorkJournalDivisions (RegUserNo, RegDate, ModUserNo, ModDate, Name, SortNo,Enabled,ParentNo)
	VALUES (ModUserNo, ModDate, ModUserNo, ModDate,Name, SortNo, 1,ParentNo)
	

	SET DivisionNo = lastval()
	
	RETURN QUERY
	SELECT DivisionNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
