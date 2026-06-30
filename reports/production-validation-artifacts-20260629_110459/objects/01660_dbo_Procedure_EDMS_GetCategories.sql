-- ─── PROCEDURE→FUNCTION: edms_getcategories ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.edms_getcategories(boolean);
CREATE OR REPLACE FUNCTION public.edms_getcategories(
    IN alsodisabled boolean
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF AlsoDisabled = 1 THEN

		RETURN QUERY
		SELECT CategoryNo, ModUserNo, ModDate, ParentNo, Name, Enabled
		FROM EDMS_Categories
		ORDER BY Name ASC
	
	END IF;
	
	ELSE BEGIN
	
		RETURN QUERY
		SELECT CategoryNo, ModUserNo, ModDate, ParentNo, Name, Enabled
		FROM EDMS_Categories
		WHERE Enabled = TRUE
		ORDER BY Name ASC
		
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
