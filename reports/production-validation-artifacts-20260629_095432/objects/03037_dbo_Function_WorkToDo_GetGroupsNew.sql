-- ─── FUNCTION: worktodo_getgroupsnew ───────────────────────────────
DROP FUNCTION IF EXISTS public.worktodo_getgroupsnew();
CREATE OR REPLACE FUNCTION public.worktodo_getgroupsnew(
) RETURNS TABLE(
    groupno text,
    name text,
    enddate text,
    startdate text,
    parentno text,
    groupno text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT GroupNo, Name, EndDate, StartDate, ParentNo, GroupNo
	FROM WorkToDo_Groups;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
