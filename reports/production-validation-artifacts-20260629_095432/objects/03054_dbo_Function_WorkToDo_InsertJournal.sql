-- ─── FUNCTION: worktodo_insertjournal ───────────────────────────────
DROP FUNCTION IF EXISTS public.worktodo_insertjournal(bigint, integer, timestamp without time zone, timestamp without time zone, integer, integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.worktodo_insertjournal(
    datano bigint,
    moduserno integer,
    moddate timestamp without time zone,
    writedate timestamp without time zone,
    progressrate integer,
    worktime integer,
    content character varying,
    typeno integer
) RETURNS TABLE(
    journalno text
)
AS $function$
DECLARE
    journalno bigint;
BEGIN


	INSERT INTO WorkToDo_Journals (DataNo, ModUserNo, ModDate, WriteDate, ProgressRate, WorkTime, Content, TypeNo)
	VALUES (DataNo, ModUserNo, ModDate, WriteDate, ProgressRate, WorkTime, Content, TypeNo)
		

	SET JournalNo = lastval()
	
	UPDATE WorkToDo_ToDoList SET ProgressRate = worktodo_insertjournal.progressrate, LatestJournalDate = worktodo_insertjournal.moddate
	WHERE DataNo = worktodo_insertjournal.datano
	
	RETURN QUERY
	SELECT JournalNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
