-- ─── FUNCTION: schedule_deletetodosharers ───────────────────────────────
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
