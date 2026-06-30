-- ─── PROCEDURE→FUNCTION: worktodo_getgroups ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.worktodo_getgroups();
CREATE OR REPLACE FUNCTION public.worktodo_getgroups(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	
	--IF (AlsoDisabled = 1) BEGIN
	
	--	SELECT GroupNo, ModUserNo, ModDate, Name, ParentNo, RepNo, EndDate, Description, SortNo, Enabled
	--	FROM WorkToDo_Groups
	
	--END
	
	--ELSE BEGIN
	
	--	SELECT GroupNo, ModUserNo, ModDate, Name, ParentNo, RepNo, EndDate, Description, SortNo, Enabled
	--	FROM WorkToDo_Groups
	--	WHERE Enabled = TRUE
		
	--END

	RETURN QUERY
	SELECT GroupNo, ModUserNo, ModDate, Name, ParentNo, RepNo, EndDate, Description, SortNo, Enabled
	FROM WorkToDo_Groups;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
