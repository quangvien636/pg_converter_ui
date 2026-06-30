-- ─── FUNCTION: worktodo_getgroupnew ───────────────────────────────
DROP FUNCTION IF EXISTS public.worktodo_getgroupnew(integer);
CREATE OR REPLACE FUNCTION public.worktodo_getgroupnew(
    groupno integer
) RETURNS TABLE(
    enddate text,
    description text,
    startdate text
)
AS $function$
BEGIN
	
	RETURN QUERY
	SELECT EndDate, Description, StartDate
	FROM WorkToDo_Groups
	WHERE GroupNo = worktodo_getgroupnew.groupno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
