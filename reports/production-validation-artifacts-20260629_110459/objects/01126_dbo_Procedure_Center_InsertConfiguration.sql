-- ─── PROCEDURE→FUNCTION: center_insertconfiguration ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.center_insertconfiguration(integer, timestamp without time zone, character varying);
CREATE OR REPLACE FUNCTION public.center_insertconfiguration(
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN key character varying
) RETURNS SETOF record
AS $function$
DECLARE
    configno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	SELECT  INTO  FROM Center_Configuration
	WHERE Key = center_insertconfiguration.key
	
	IF ConfigNo IS NULL THEN
	
		INSERT INTO Center_Configuration (ModUserNo, ModDate, Key, Value)
		VALUES (ModUserNo, ModDate, Key, Value)
		
		ConfigNo := lastval();
	END IF;
	
	ELSE BEGIN
	
		UPDATE Center_Configuration SET
			ModUserNo = center_insertconfiguration.moduserno,
			ModDate = center_insertconfiguration.moddate,
			Key = center_insertconfiguration.key,
			Value = Value
		WHERE ConfigNo = ConfigNo
	
	END;
	
	RETURN QUERY
	SELECT ConfigNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
