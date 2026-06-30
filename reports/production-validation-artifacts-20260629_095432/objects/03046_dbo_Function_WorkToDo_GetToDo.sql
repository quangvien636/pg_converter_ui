-- ─── FUNCTION: worktodo_gettodo ───────────────────────────────
DROP FUNCTION IF EXISTS public.worktodo_gettodo(bigint);
CREATE OR REPLACE FUNCTION public.worktodo_gettodo(
    datano bigint
) RETURNS TABLE(
    datano text,
    todono text,
    moduserno text,
    moddate text,
    subject text,
    content text,
    filecount text,
    typeno text,
    groupno text,
    repno text,
    col11 text
)
AS $function$
BEGIN


	
	RETURN QUERY
	SELECT DataNo, ToDoNo, ModUserNo, ModDate, Subject, Content, FileCount, TypeNo, GroupNo, RepNo,
	(select case LanguageSign when 'KO' then Name else  Name_EN end from Organization_Users where UserNo = RepNo) as RepName,
		StartDate, EndDate, ActualityEndDate, ProgressRate, Priority, State, StateModDate, Passed, LatestJournalDate
	FROM WorkToDo_ToDoList
	WHERE DataNo = worktodo_gettodo.datano;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
