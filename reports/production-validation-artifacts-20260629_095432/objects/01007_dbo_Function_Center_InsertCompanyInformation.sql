-- ─── FUNCTION: center_insertcompanyinformation ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_insertcompanyinformation(integer, timestamp without time zone, character varying);
CREATE OR REPLACE FUNCTION public.center_insertcompanyinformation(
    moduserno integer,
    moddate timestamp without time zone,
    key character varying
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    infono integer;
BEGIN



	SELECT InfoNo = InfoNo
	FROM Center_CompanyInformation
	WHERE Key = center_insertcompanyinformation.key
	
	IF (InfoNo IS NULL) BEGIN
	
		INSERT INTO Center_CompanyInformation (ModUserNo, ModDate, Key, Value)
		VALUES (ModUserNo, ModDate, Key, Value)
		
		SET InfoNo = lastval()
	
	END
	
	ELSE BEGIN
	
		UPDATE Center_CompanyInformation SET
			ModUserNo = center_insertcompanyinformation.moduserno,
			ModDate = center_insertcompanyinformation.moddate,
			Key = center_insertcompanyinformation.key,
			Value = Value
		WHERE InfoNo = InfoNo
	
	END
	
	RETURN QUERY
	SELECT InfoNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
