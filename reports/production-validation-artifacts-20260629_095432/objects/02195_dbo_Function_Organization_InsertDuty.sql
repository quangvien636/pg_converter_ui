-- ─── FUNCTION: organization_insertduty ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_insertduty(integer, timestamp without time zone, character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.organization_insertduty(
    moduserno integer,
    moddate timestamp without time zone,
    name character varying,
    name_en character varying,
    name_ch character varying,
    name_jp character varying
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    sortno integer;
    dutyno integer;
BEGIN



	SET SortNo = (SELECT MAX(SortNo) FROM Organization_Positions)
	
	IF (SortNo IS NULL) BEGIN
	
		SET SortNo = 1
	
	END
	
	ELSE BEGIN
	
		SET SortNo = SortNo + 1
	
	END
	
	INSERT INTO Organization_Duties (ModUserNo, ModDate, Name, Name_EN, SortNo, Enabled,Name_CH,Name_JP,Name_VN)
	VALUES (ModUserNo, ModDate, Name, Name_EN, SortNo, 1,Name_CH,Name_JP,Name_VN)
	

	SET DutyNo = lastval()
	
	RETURN QUERY
	SELECT DutyNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
