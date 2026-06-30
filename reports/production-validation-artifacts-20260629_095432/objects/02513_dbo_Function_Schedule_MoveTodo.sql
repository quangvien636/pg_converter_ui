-- ─── FUNCTION: schedule_movetodo ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_movetodo(integer, date);
CREATE OR REPLACE FUNCTION public.schedule_movetodo(
    todono integer,
    completedate date
) RETURNS void
AS $function$
BEGIN

	UPDATE ScheduleToDos
	SET
		ModUserNo = UserNo,
		ModDate = NOW(),
		CompleteDate = schedule_movetodo.completedate
	WHERE ToDoNo = schedule_movetodo.todono;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
