-- ─── PROCEDURE→FUNCTION: center_getcompanyinformation ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.center_getcompanyinformation(integer, timestamp without time zone, character varying);
CREATE OR REPLACE FUNCTION public.center_getcompanyinformation(
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN key character varying
) RETURNS SETOF record
AS $function$
DECLARE
    infono integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	SELECT InfoNo INTO infono FROM Center_CompanyInformation WHERE Key = center_getcompanyinformation.key

	IF InfoNo IS NULL THEN
	
		INSERT INTO Center_CompanyInformation (ModUserNo, ModDate, Key, Value)
		VALUES (ModUserNo, ModDate, Key, DefaultValue)
		
		InfoNo := lastval();
	END IF;
	
	RETURN QUERY
	SELECT InfoNo, ModUserNo, ModDate, Key, Value
	FROM Center_CompanyInformation
	WHERE InfoNo = InfoNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
