-- ─── PROCEDURE→FUNCTION: worktodo_getfilesoftodo ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.worktodo_getfilesoftodo(bigint);
CREATE OR REPLACE FUNCTION public.worktodo_getfilesoftodo(
    IN datano bigint
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT FileNo, Name, Length
	FROM WorkToDo_FilesOfToDo
	WHERE DataNo = worktodo_getfilesoftodo.datano;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
