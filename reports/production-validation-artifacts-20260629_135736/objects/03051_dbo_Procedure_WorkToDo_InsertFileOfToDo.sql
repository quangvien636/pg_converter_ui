-- ─── PROCEDURE→FUNCTION: worktodo_insertfileoftodo ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.worktodo_insertfileoftodo(bigint, character varying, integer);
CREATE OR REPLACE FUNCTION public.worktodo_insertfileoftodo(
    IN datano bigint,
    IN name character varying,
    IN length integer
) RETURNS SETOF record
AS $function$
DECLARE
    fileno bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO WorkToDo_FilesOfToDo (DataNo, Name, Length)
	VALUES (DataNo, Name, Length)
	

	FileNo := lastval();
	RETURN QUERY
	SELECT FileNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
