-- ─── FUNCTION: worktodo_updatetodotypebytitle ───────────────────────────────
DROP FUNCTION IF EXISTS public.worktodo_updatetodotypebytitle(integer);
CREATE OR REPLACE FUNCTION public.worktodo_updatetodotypebytitle(
    typeno integer
) RETURNS void
AS $function$
BEGIN

	UPDATE WorkToDo_ToDoTypes SET
		Title = Title
	WHERE TypeNo = worktodo_updatetodotypebytitle.typeno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
