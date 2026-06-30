-- ─── PROCEDURE→FUNCTION: worktodo_getgroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.worktodo_getgroup(integer);
CREATE OR REPLACE FUNCTION public.worktodo_getgroup(
    IN groupno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	
	RETURN QUERY
	SELECT ModUserNo, ModDate, Name, ParentNo, RepNo, EndDate, Description, SortNo, Enabled
	FROM WorkToDo_Groups
	WHERE GroupNo = worktodo_getgroup.groupno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
