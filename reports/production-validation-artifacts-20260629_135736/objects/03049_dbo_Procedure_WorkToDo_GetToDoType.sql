-- ─── PROCEDURE→FUNCTION: worktodo_gettodotype ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.worktodo_gettodotype(integer);
CREATE OR REPLACE FUNCTION public.worktodo_gettodotype(
    IN typeno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT ModUserNo, ModDate, Title, SortNo, Enabled
	FROM WorkToDo_ToDoTypes WHERE TypeNo = worktodo_gettodotype.typeno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
