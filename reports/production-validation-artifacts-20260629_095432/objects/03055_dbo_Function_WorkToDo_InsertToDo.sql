-- ─── FUNCTION: worktodo_inserttodo ───────────────────────────────
DROP FUNCTION IF EXISTS public.worktodo_inserttodo(bigint, timestamp without time zone, character varying, character varying, integer, integer, integer, bigint, timestamp without time zone, integer, integer, timestamp without time zone, boolean);
CREATE OR REPLACE FUNCTION public.worktodo_inserttodo(
    moduserno bigint,
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
    statemoddate timestamp without time zone,
    passed boolean
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    todono integer;
    datano bigint;
BEGIN



	SET ToDoNo = (SELECT COALESCE(MAX(ToDoNo), 0) + 1 FROM WorkToDo_ToDoList WHERE RepNo = worktodo_inserttodo.repno)
	
	INSERT INTO WorkToDo_ToDoList (ToDoNo, ModUserNo, ModDate, Subject, Content, FileCount, TypeNo, GroupNo, RepNo,
		StartDate, EndDate, ActualityEndDate, ProgressRate, Priority, State, StateModDate, Passed, LatestJournalDate)
	VALUES (ToDoNo, ModUserNo, ModDate, Subject, Content, FileCount, TypeNo, GroupNo, RepNo,
		NOW(), EndDate, EndDate, 0, Priority, State, StateModDate, Passed, NOW())
		

	SET DataNo = lastval()
	
	RETURN QUERY
	SELECT DataNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
