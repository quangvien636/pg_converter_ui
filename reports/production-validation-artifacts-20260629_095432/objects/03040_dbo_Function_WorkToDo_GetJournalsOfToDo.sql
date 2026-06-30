-- ─── FUNCTION: worktodo_getjournalsoftodo ───────────────────────────────
DROP FUNCTION IF EXISTS public.worktodo_getjournalsoftodo(bigint);
CREATE OR REPLACE FUNCTION public.worktodo_getjournalsoftodo(
    datano bigint
) RETURNS TABLE(
    journalno text,
    moduserno text,
    moddate text,
    writedate text,
    progressrate text,
    worktime text,
    content text,
    typeno text,
    totalworktime text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT JournalNo, ModUserNo, ModDate, WriteDate, ProgressRate, WorkTime, Content, TypeNo,sum(WorkTime) over() as TotalWorkTime
	FROM WorkToDo_Journals
	WHERE DataNo = worktodo_getjournalsoftodo.datano
	ORDER BY WriteDate DESC, JournalNo DESC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
