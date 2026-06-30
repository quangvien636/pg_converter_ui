-- ─── FUNCTION: worktodo_updatetodotypebysortno ───────────────────────────────
DROP FUNCTION IF EXISTS public.worktodo_updatetodotypebysortno(integer);
CREATE OR REPLACE FUNCTION public.worktodo_updatetodotypebysortno(
    typeno integer
) RETURNS void
AS $function$
BEGIN

	UPDATE WorkToDo_ToDoTypes SET
		SortNo = SortNo
	WHERE TypeNo = worktodo_updatetodotypebysortno.typeno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
