-- ─── PROCEDURE→FUNCTION: schedule_movetodo ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_movetodo(integer, date);
CREATE OR REPLACE FUNCTION public.schedule_movetodo(
    IN todono integer,
    IN completedate date
) RETURNS void
AS $function$
BEGIN

	UPDATE ScheduleToDos
	ModUserNo := UserNo,;
		ModDate = NOW(),
		CompleteDate = schedule_movetodo.completedate
	WHERE ToDoNo = schedule_movetodo.todono;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
