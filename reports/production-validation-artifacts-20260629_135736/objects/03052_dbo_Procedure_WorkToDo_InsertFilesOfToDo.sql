-- ─── PROCEDURE→FUNCTION: worktodo_insertfilesoftodo ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.worktodo_insertfilesoftodo(bigint, character varying, integer);
CREATE OR REPLACE FUNCTION public.worktodo_insertfilesoftodo(
    IN datano bigint,
    IN name character varying,
    IN length integer
) RETURNS void
AS $function$
BEGIN


	
	INSERT INTO WorkToDo_FilesOfToDo(DataNo,Name,Length)
	values (DataNo,Name,Length);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
