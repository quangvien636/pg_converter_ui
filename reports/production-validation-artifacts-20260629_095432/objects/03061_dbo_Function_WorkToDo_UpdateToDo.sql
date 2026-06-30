-- ─── FUNCTION: worktodo_updatetodo ───────────────────────────────
DROP FUNCTION IF EXISTS public.worktodo_updatetodo(bigint, timestamp without time zone, character varying, character varying, integer, integer, integer, bigint, timestamp without time zone, integer, integer, boolean);
CREATE OR REPLACE FUNCTION public.worktodo_updatetodo(
    datano bigint,
    moddate timestamp without time zone,
    subject character varying,
    content character varying,
    filecount integer,
    typeno integer,
    groupno integer,
    repno bigint,
    enddate timestamp without time zone,
    priority integer,
    state integer,
    passed boolean
) RETURNS void
AS $function$
BEGIN


	UPDATE WorkToDo_ToDoList Set ModDate=worktodo_updatetodo.moddate, Subject=worktodo_updatetodo.subject, Content=worktodo_updatetodo.content,FileCount=worktodo_updatetodo.filecount,TypeNo=worktodo_updatetodo.typeno,GroupNo=worktodo_updatetodo.groupno,RepNo=worktodo_updatetodo.repno,EndDate=worktodo_updatetodo.enddate,Priority=worktodo_updatetodo.priority,
	State=worktodo_updatetodo.state,Passed=worktodo_updatetodo.passed where DataNo=worktodo_updatetodo.datano;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
