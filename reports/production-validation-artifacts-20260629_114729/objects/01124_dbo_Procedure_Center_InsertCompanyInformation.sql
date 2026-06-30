-- ─── PROCEDURE→FUNCTION: center_insertcompanyinformation ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.center_insertcompanyinformation(integer, timestamp without time zone, character varying);
CREATE OR REPLACE FUNCTION public.center_insertcompanyinformation(
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN key character varying
) RETURNS SETOF record
AS $function$
DECLARE
    infono integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	SELECT  INTO  FROM Center_CompanyInformation
	WHERE Key = center_insertcompanyinformation.key
	
	IF InfoNo IS NULL THEN
	
		INSERT INTO Center_CompanyInformation (ModUserNo, ModDate, Key, Value)
		VALUES (ModUserNo, ModDate, Key, Value)
		
		InfoNo := lastval();
	END IF;
	
	ELSE BEGIN
	
		UPDATE Center_CompanyInformation SET
			ModUserNo = center_insertcompanyinformation.moduserno,
			ModDate = center_insertcompanyinformation.moddate,
			Key = center_insertcompanyinformation.key,
			Value = Value
		WHERE InfoNo = InfoNo
	
	END;
	
	RETURN QUERY
	SELECT InfoNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
