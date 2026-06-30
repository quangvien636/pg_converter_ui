-- ─── FUNCTION: work_insertadminregularworkgroupdivisions ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_insertadminregularworkgroupdivisions(integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.work_insertadminregularworkgroupdivisions(
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



	SET SortNo = (SELECT MAX(SortNo) FROM RegularWorkGroupDivisions)
	
	IF (SortNo IS NULL) BEGIN
	
		SET SortNo = 1
	
	END
	
	ELSE BEGIN
	
		SET SortNo = SortNo + 1
	
	END

	INSERT INTO RegularWorkGroupDivisions (RegUserNo, RegDate, ModUserNo, ModDate, Name, SortNo,Enabled)
	VALUES (ModUserNo, ModDate, ModUserNo, ModDate,Name, SortNo, 1)
	

	SET DivisionNo = lastval()
	
	RETURN QUERY
	SELECT DivisionNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
