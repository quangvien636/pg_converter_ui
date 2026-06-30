-- ─── FUNCTION: worktodo_getgroupsbystate ───────────────────────────────
DROP FUNCTION IF EXISTS public.worktodo_getgroupsbystate(boolean);
CREATE OR REPLACE FUNCTION public.worktodo_getgroupsbystate(
    state boolean
) RETURNS TABLE(
    groupno text,
    name text
)
AS $function$
BEGIN
	
	RETURN QUERY
	SELECT GroupNo, Name
	FROM WorkToDo_Groups
	WHERE Enabled = worktodo_getgroupsbystate.state;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
