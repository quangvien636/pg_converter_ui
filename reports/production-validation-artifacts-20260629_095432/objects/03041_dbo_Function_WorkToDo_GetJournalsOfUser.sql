-- ─── FUNCTION: worktodo_getjournalsofuser ───────────────────────────────
DROP FUNCTION IF EXISTS public.worktodo_getjournalsofuser(integer, date);
CREATE OR REPLACE FUNCTION public.worktodo_getjournalsofuser(
    userno integer,
    writedate date
) RETURNS TABLE(
    journalno text,
    datano text,
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
	SELECT J.JournalNo, J.DataNo, J.ModDate, J.WriteDate, J.ProgressRate, J.WorkTime, J.Content, J.TypeNo,
		T.Subject AS ToDo_Subject,sum(WorkTime) over() as TotalWorkTime
	FROM WorkToDo_Journals J 
	INNER JOIN WorkToDo_ToDoList T ON T.DataNo = J.DataNo
	WHERE J.ModUserNo = worktodo_getjournalsofuser.userno AND J.WriteDate = worktodo_getjournalsofuser.writedate
	ORDER BY J.WriteDate DESC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
