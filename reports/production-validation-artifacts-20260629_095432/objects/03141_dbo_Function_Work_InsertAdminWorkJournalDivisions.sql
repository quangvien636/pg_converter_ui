-- ─── FUNCTION: work_insertadminworkjournaldivisions ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_insertadminworkjournaldivisions(integer, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.work_insertadminworkjournaldivisions(
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



	SET SortNo = (SELECT MAX(SortNo) FROM WorkJournalDivisions WHERE ParentNo = work_insertadminworkjournaldivisions.parentno)
	
	IF (SortNo IS NULL) BEGIN
	
		SET SortNo = 1
	
	END
	
	ELSE BEGIN
	
		SET SortNo = SortNo + 1
	
	END

	INSERT INTO WorkJournalDivisions (RegUserNo, RegDate, ModUserNo, ModDate, Name, SortNo,Enabled,ParentNo)
	VALUES (ModUserNo, ModDate, ModUserNo, ModDate,Name, SortNo, 1,ParentNo)
	

	SET DivisionNo = lastval()
	
	RETURN QUERY
	SELECT DivisionNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
