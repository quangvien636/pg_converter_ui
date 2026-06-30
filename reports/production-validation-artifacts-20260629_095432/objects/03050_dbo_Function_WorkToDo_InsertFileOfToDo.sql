-- ─── FUNCTION: worktodo_insertfileoftodo ───────────────────────────────
DROP FUNCTION IF EXISTS public.worktodo_insertfileoftodo(bigint, character varying, integer);
CREATE OR REPLACE FUNCTION public.worktodo_insertfileoftodo(
    datano bigint,
    name character varying,
    length integer
) RETURNS TABLE(
    fileno text
)
AS $function$
DECLARE
    fileno bigint;
BEGIN


	INSERT INTO WorkToDo_FilesOfToDo (DataNo, Name, Length)
	VALUES (DataNo, Name, Length)
	

	SET FileNo = lastval()
	
	RETURN QUERY
	SELECT FileNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
