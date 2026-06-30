-- ─── PROCEDURE→FUNCTION: schedule_deletetodosharers ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_deletetodosharers();
CREATE OR REPLACE FUNCTION public.schedule_deletetodosharers(
) RETURNS void
AS $function$
BEGIN

	DELETE FROM ScheduleToDoSharers WHERE ToDoNo = ToDoNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
