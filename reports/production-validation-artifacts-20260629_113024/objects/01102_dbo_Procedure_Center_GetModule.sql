-- ─── PROCEDURE→FUNCTION: center_getmodule ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.center_getmodule(integer);
CREATE OR REPLACE FUNCTION public.center_getmodule(
    IN moduleno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF ModuleNo = 0 THEN
	
		RETURN QUERY
		SELECT ModuleNo, Code, SortNo, Enabled
		FROM Center_Modules
		WHERE Code = Code
	
	END IF;
	
	ELSE BEGIN
	
		RETURN QUERY
		SELECT ModuleNo, Code, SortNo, Enabled
		FROM Center_Modules
		WHERE ModuleNo = center_getmodule.moduleno
	
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
