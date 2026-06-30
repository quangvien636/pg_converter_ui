-- ─── FUNCTION: worktodo_getfileoftodo ───────────────────────────────
DROP FUNCTION IF EXISTS public.worktodo_getfileoftodo(bigint);
CREATE OR REPLACE FUNCTION public.worktodo_getfileoftodo(
    fileno bigint
) RETURNS TABLE(
    datano text,
    name text,
    length text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT DataNo, Name, Length
	FROM WorkToDo_FilesOfToDo
	WHERE FileNo = worktodo_getfileoftodo.fileno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
