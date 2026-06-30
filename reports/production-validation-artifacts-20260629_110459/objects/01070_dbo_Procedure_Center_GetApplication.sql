-- ─── PROCEDURE→FUNCTION: center_getapplication ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.center_getapplication(integer);
CREATE OR REPLACE FUNCTION public.center_getapplication(
    IN applicationno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF ApplicationNo = 0 THEN
	
		RETURN QUERY
		SELECT ApplicationNo, ProjectCode, SortNo, Status, Option
		FROM Center_Applications
		WHERE ProjectCode = ProjectCode
	
	END IF;
	
	ELSE BEGIN
	
		RETURN QUERY
		SELECT ApplicationNo, ProjectCode, SortNo, Status, Option
		FROM Center_Applications
		WHERE ApplicationNo = center_getapplication.applicationno
	
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
