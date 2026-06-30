-- ─── FUNCTION: organization_insertposition ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_insertposition(integer, timestamp without time zone, character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.organization_insertposition(
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
    positionno integer;
BEGIN



	SET SortNo = (SELECT MAX(SortNo) FROM Organization_Positions)
	
	IF (SortNo IS NULL) BEGIN
	
		SET SortNo = 1
	
	END
	
	ELSE BEGIN
	
		SET SortNo = SortNo + 1
	
	END

	INSERT INTO Organization_Positions (ModUserNo, ModDate, Name, Name_EN, SortNo, Enabled,Name_CH,Name_JP,Name_VN)
	VALUES (ModUserNo, ModDate, Name, Name_EN, SortNo, 1,Name_CH,Name_JP,Name_VN)
	

	SET PositionNo = lastval()
	
	RETURN QUERY
	SELECT PositionNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
