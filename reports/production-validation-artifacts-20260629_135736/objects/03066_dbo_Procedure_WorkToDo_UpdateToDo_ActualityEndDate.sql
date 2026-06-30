-- ─── PROCEDURE→FUNCTION: worktodo_updatetodo_actualityenddate ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.worktodo_updatetodo_actualityenddate(bigint, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.worktodo_updatetodo_actualityenddate(
    IN datano bigint,
    IN actualityenddate timestamp without time zone
) RETURNS void
AS $function$
BEGIN


	UPDATE WorkToDo_ToDoList SET ActualityEndDate = worktodo_updatetodo_actualityenddate.actualityenddate
	WHERE DataNo = worktodo_updatetodo_actualityenddate.datano;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
