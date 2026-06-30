-- ─── FUNCTION: center_getcompanyinformation ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_getcompanyinformation(integer, timestamp without time zone, character varying);
CREATE OR REPLACE FUNCTION public.center_getcompanyinformation(
    moduserno integer,
    moddate timestamp without time zone,
    key character varying
) RETURNS TABLE(
    infono text,
    moduserno text,
    moddate text,
    key text,
    value text
)
AS $function$
DECLARE
    infono integer;
BEGIN



	SELECT InfoNo = InfoNo FROM Center_CompanyInformation WHERE Key = center_getcompanyinformation.key

	IF (InfoNo IS NULL) BEGIN
	
		INSERT INTO Center_CompanyInformation (ModUserNo, ModDate, Key, Value)
		VALUES (ModUserNo, ModDate, Key, DefaultValue)
		
		SET InfoNo = lastval()
	
	END
	
	RETURN QUERY
	SELECT InfoNo, ModUserNo, ModDate, Key, Value
	FROM Center_CompanyInformation
	WHERE InfoNo = InfoNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
