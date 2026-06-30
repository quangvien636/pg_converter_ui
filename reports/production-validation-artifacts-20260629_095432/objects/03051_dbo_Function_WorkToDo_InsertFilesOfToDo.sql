-- ─── FUNCTION: worktodo_insertfilesoftodo ───────────────────────────────
DROP FUNCTION IF EXISTS public.worktodo_insertfilesoftodo(bigint, character varying, integer);
CREATE OR REPLACE FUNCTION public.worktodo_insertfilesoftodo(
    datano bigint,
    name character varying,
    length integer
) RETURNS void
AS $function$
BEGIN


	
	INSERT INTO WorkToDo_FilesOfToDo(DataNo,Name,Length)
	values (DataNo,Name,Length);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
