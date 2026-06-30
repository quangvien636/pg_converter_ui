-- ─── FUNCTION: worktodo_updatetodo_startdate ───────────────────────────────
DROP FUNCTION IF EXISTS public.worktodo_updatetodo_startdate(bigint, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.worktodo_updatetodo_startdate(
    datano bigint,
    startdate timestamp without time zone
) RETURNS void
AS $function$
BEGIN


	UPDATE WorkToDo_ToDoList SET StartDate = worktodo_updatetodo_startdate.startdate WHERE DataNo = worktodo_updatetodo_startdate.datano;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
