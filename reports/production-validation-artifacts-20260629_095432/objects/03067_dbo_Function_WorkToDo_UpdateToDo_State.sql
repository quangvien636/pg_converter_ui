-- ─── FUNCTION: worktodo_updatetodo_state ───────────────────────────────
DROP FUNCTION IF EXISTS public.worktodo_updatetodo_state(bigint, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.worktodo_updatetodo_state(
    datano bigint,
    state integer,
    moddate timestamp without time zone
) RETURNS void
AS $function$
BEGIN


	UPDATE WorkToDo_ToDoList SET State = worktodo_updatetodo_state.state , StateModDate = worktodo_updatetodo_state.moddate
	WHERE DataNo = worktodo_updatetodo_state.datano;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
