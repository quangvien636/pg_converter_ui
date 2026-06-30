-- ─── FUNCTION: center_getconfiguration ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_getconfiguration(integer, timestamp without time zone, character varying);
CREATE OR REPLACE FUNCTION public.center_getconfiguration(
    moduserno integer,
    moddate timestamp without time zone,
    key character varying
) RETURNS TABLE(
    configno text,
    moduserno text,
    moddate text,
    key text,
    value text
)
AS $function$
DECLARE
    configno integer;
BEGIN



	SELECT ConfigNo = ConfigNo FROM Center_Configuration WHERE Key = center_getconfiguration.key

	IF (ConfigNo IS NULL) BEGIN
	
		INSERT INTO Center_Configuration (ModUserNo, ModDate, Key, Value)
		VALUES (ModUserNo, ModDate, Key, DefaultValue)
		
		SET ConfigNo = lastval()
	
	END
	
	RETURN QUERY
	SELECT ConfigNo, ModUserNo, ModDate, Key, Value
	FROM Center_Configuration
	WHERE ConfigNo = ConfigNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
