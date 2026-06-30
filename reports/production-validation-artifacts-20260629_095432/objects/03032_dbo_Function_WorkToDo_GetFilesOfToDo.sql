-- ─── FUNCTION: worktodo_getfilesoftodo ───────────────────────────────
DROP FUNCTION IF EXISTS public.worktodo_getfilesoftodo(bigint);
CREATE OR REPLACE FUNCTION public.worktodo_getfilesoftodo(
    datano bigint
) RETURNS TABLE(
    fileno text,
    name text,
    length text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT FileNo, Name, Length
	FROM WorkToDo_FilesOfToDo
	WHERE DataNo = worktodo_getfilesoftodo.datano;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
