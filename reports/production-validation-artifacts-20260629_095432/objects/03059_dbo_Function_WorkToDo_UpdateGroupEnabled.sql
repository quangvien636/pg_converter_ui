-- ─── FUNCTION: worktodo_updategroupenabled ───────────────────────────────
DROP FUNCTION IF EXISTS public.worktodo_updategroupenabled(boolean, integer);
CREATE OR REPLACE FUNCTION public.worktodo_updategroupenabled(
    enabled boolean,
    groupno integer
) RETURNS void
AS $function$
BEGIN
 

	Update WorkToDo_Groups set Enabled=worktodo_updategroupenabled.enabled where GroupNo=worktodo_updategroupenabled.groupno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
