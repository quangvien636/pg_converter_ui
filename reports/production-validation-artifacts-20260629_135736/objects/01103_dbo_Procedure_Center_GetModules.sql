-- ─── PROCEDURE→FUNCTION: center_getmodules ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.center_getmodules(boolean);
CREATE OR REPLACE FUNCTION public.center_getmodules(
    IN alsodisabled boolean
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF AlsoDisabled = 1 THEN

		RETURN QUERY
		SELECT ModuleNo, Code, SortNo, Enabled
		FROM Center_Modules
		ORDER BY SortNo
	
	END IF;
	
	ELSE BEGIN
	
		RETURN QUERY
		SELECT ModuleNo, Code, SortNo, Enabled
		FROM Center_Modules
		WHERE Enabled = TRUE
		ORDER BY SortNo
		
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
