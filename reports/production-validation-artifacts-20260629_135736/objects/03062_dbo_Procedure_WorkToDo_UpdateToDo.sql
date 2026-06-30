-- ─── PROCEDURE→FUNCTION: worktodo_updatetodo ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.worktodo_updatetodo(bigint, timestamp without time zone, character varying, character varying, integer, integer, integer, bigint, timestamp without time zone, integer, integer, boolean);
CREATE OR REPLACE FUNCTION public.worktodo_updatetodo(
    IN datano bigint,
    IN moddate timestamp without time zone,
    IN subject character varying,
    IN content character varying,
    IN filecount integer,
    IN typeno integer,
    IN groupno integer,
    IN repno bigint,
    IN enddate timestamp without time zone,
    IN priority integer,
    IN state integer,
    IN passed boolean
) RETURNS void
AS $function$
BEGIN


	UPDATE WorkToDo_ToDoList Set ModDate=worktodo_updatetodo.moddate, Subject=worktodo_updatetodo.subject, Content=worktodo_updatetodo.content,FileCount=worktodo_updatetodo.filecount,TypeNo=worktodo_updatetodo.typeno,GroupNo=worktodo_updatetodo.groupno,RepNo=worktodo_updatetodo.repno,EndDate=worktodo_updatetodo.enddate,Priority=worktodo_updatetodo.priority,
	State=worktodo_updatetodo.state,Passed=worktodo_updatetodo.passed where DataNo=worktodo_updatetodo.datano;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
