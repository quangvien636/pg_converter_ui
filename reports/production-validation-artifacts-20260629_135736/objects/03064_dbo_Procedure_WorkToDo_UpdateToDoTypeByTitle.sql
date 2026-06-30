-- ─── PROCEDURE→FUNCTION: worktodo_updatetodotypebytitle ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.worktodo_updatetodotypebytitle(integer);
CREATE OR REPLACE FUNCTION public.worktodo_updatetodotypebytitle(
    IN typeno integer
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
