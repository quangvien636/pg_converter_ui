-- ─── PROCEDURE→FUNCTION: worktodo_getjournalsbywritedate ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.worktodo_getjournalsbywritedate(date);
CREATE OR REPLACE FUNCTION public.worktodo_getjournalsbywritedate(
    IN writedate date
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
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
