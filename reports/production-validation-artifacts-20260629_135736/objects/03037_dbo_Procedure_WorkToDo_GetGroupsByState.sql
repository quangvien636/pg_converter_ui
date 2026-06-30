-- ─── PROCEDURE→FUNCTION: worktodo_getgroupsbystate ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.worktodo_getgroupsbystate(boolean);
CREATE OR REPLACE FUNCTION public.worktodo_getgroupsbystate(
    IN state boolean
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
	
	RETURN QUERY
	SELECT GroupNo, Name
	FROM WorkToDo_Groups
	WHERE Enabled = worktodo_getgroupsbystate.state;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
