-- ─── FUNCTION: worktodo_getjournalsbywritedate ───────────────────────────────
DROP FUNCTION IF EXISTS public.worktodo_getjournalsbywritedate(date);
CREATE OR REPLACE FUNCTION public.worktodo_getjournalsbywritedate(
    writedate date
) RETURNS TABLE(
    journalno text,
    datano text,
    moduserno text,
    moddate text,
    writedate text,
    progressrate text,
    worktime text,
    content text,
    typeno text,
    todo_subject text,
    totalworktime text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT J.JournalNo, J.DataNo, J.ModUserNo, J.ModDate, J.WriteDate, J.ProgressRate, J.WorkTime, J.Content, J.TypeNo,
		T.Subject AS ToDo_Subject,sum(WorkTime) over() as TotalWorkTime
	FROM WorkToDo_Journals J
	INNER JOIN WorkToDo_ToDoList T ON T.DataNo = J.DataNo
	WHERE J.WriteDate = worktodo_getjournalsbywritedate.writedate
	ORDER BY J.ModUserNo DESC, J.WriteDate DESC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
