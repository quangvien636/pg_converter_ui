-- ─── PROCEDURE→FUNCTION: worktodo_updatetodotypebysortno ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.worktodo_updatetodotypebysortno(integer);
CREATE OR REPLACE FUNCTION public.worktodo_updatetodotypebysortno(
    IN typeno integer
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
