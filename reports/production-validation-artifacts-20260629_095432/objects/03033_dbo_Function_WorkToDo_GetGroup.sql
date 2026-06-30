-- ─── FUNCTION: worktodo_getgroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.worktodo_getgroup(integer);
CREATE OR REPLACE FUNCTION public.worktodo_getgroup(
    groupno integer
) RETURNS TABLE(
    moduserno text,
    moddate text,
    name text,
    parentno text,
    repno text,
    enddate text,
    description text,
    sortno text,
    enabled text
)
AS $function$
BEGIN

	
	RETURN QUERY
	SELECT ModUserNo, ModDate, Name, ParentNo, RepNo, EndDate, Description, SortNo, Enabled
	FROM WorkToDo_Groups
	WHERE GroupNo = worktodo_getgroup.groupno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
