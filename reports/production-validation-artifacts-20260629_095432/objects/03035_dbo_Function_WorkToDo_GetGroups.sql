-- ─── FUNCTION: worktodo_getgroups ───────────────────────────────
DROP FUNCTION IF EXISTS public.worktodo_getgroups();
CREATE OR REPLACE FUNCTION public.worktodo_getgroups(
) RETURNS TABLE(
    groupno text,
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

	
	--IF (AlsoDisabled = 1) BEGIN
	
	--	SELECT GroupNo, ModUserNo, ModDate, Name, ParentNo, RepNo, EndDate, Description, SortNo, Enabled
	--	FROM WorkToDo_Groups
	
	--END
	
	--ELSE BEGIN
	
	--	SELECT GroupNo, ModUserNo, ModDate, Name, ParentNo, RepNo, EndDate, Description, SortNo, Enabled
	--	FROM WorkToDo_Groups
	--	WHERE Enabled = TRUE
		
	--END

	RETURN QUERY
	SELECT GroupNo, ModUserNo, ModDate, Name, ParentNo, RepNo, EndDate, Description, SortNo, Enabled
	FROM WorkToDo_Groups;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
