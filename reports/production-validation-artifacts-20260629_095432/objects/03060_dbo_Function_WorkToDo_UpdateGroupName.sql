-- ─── FUNCTION: worktodo_updategroupname ───────────────────────────────
DROP FUNCTION IF EXISTS public.worktodo_updategroupname(character varying, integer);
CREATE OR REPLACE FUNCTION public.worktodo_updategroupname(
    name character varying,
    groupno integer
) RETURNS void
AS $function$
BEGIN
 

	Update WorkToDo_Groups set Name=worktodo_updategroupname.name where GroupNo=worktodo_updategroupname.groupno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
