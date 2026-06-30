-- ─── FUNCTION: center_insertconfiguration ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_insertconfiguration(integer, timestamp without time zone, character varying);
CREATE OR REPLACE FUNCTION public.center_insertconfiguration(
    moduserno integer,
    moddate timestamp without time zone,
    key character varying
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    configno integer;
BEGIN



	SELECT ConfigNo = ConfigNo
	FROM Center_Configuration
	WHERE Key = center_insertconfiguration.key
	
	IF (ConfigNo IS NULL) BEGIN
	
		INSERT INTO Center_Configuration (ModUserNo, ModDate, Key, Value)
		VALUES (ModUserNo, ModDate, Key, Value)
		
		SET ConfigNo = lastval()
	
	END
	
	ELSE BEGIN
	
		UPDATE Center_Configuration SET
			ModUserNo = center_insertconfiguration.moduserno,
			ModDate = center_insertconfiguration.moddate,
			Key = center_insertconfiguration.key,
			Value = Value
		WHERE ConfigNo = ConfigNo
	
	END
	
	RETURN QUERY
	SELECT ConfigNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
