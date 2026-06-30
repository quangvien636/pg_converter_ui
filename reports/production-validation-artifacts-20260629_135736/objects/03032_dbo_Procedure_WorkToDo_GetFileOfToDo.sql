-- ─── PROCEDURE→FUNCTION: worktodo_getfileoftodo ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.worktodo_getfileoftodo(bigint);
CREATE OR REPLACE FUNCTION public.worktodo_getfileoftodo(
    IN fileno bigint
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT DataNo, Name, Length
	FROM WorkToDo_FilesOfToDo
	WHERE FileNo = worktodo_getfileoftodo.fileno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
