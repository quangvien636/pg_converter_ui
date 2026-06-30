-- ─── FUNCTION: worktodo_totalworkingtimebygroupno ───────────────────────────────
DROP FUNCTION IF EXISTS public.worktodo_totalworkingtimebygroupno(integer);
CREATE OR REPLACE FUNCTION public.worktodo_totalworkingtimebygroupno(
    groupno integer
) RETURNS TABLE(
    datano text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT SUM(WorkTime) as wt
	FROM public."WorkToDo_Journals"
	WHERE DataNo in(
		SELECT DataNo   
		FROM public."WorkToDo_ToDoList"
		WHERE GroupNo = worktodo_totalworkingtimebygroupno.groupno
		);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
