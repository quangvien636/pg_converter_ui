-- ─── PROCEDURE→FUNCTION: center_getconfiguration ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.center_getconfiguration(integer, timestamp without time zone, character varying);
CREATE OR REPLACE FUNCTION public.center_getconfiguration(
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN key character varying
) RETURNS SETOF record
AS $function$
DECLARE
    configno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	SELECT ConfigNo INTO configno FROM Center_Configuration WHERE Key = center_getconfiguration.key

	IF ConfigNo IS NULL THEN
	
		INSERT INTO Center_Configuration (ModUserNo, ModDate, Key, Value)
		VALUES (ModUserNo, ModDate, Key, DefaultValue)
		
		ConfigNo := lastval();
	END IF;
	
	RETURN QUERY
	SELECT ConfigNo, ModUserNo, ModDate, Key, Value
	FROM Center_Configuration
	WHERE ConfigNo = ConfigNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
