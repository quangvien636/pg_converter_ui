-- ─── PROCEDURE→FUNCTION: worktodo_updategroupenabled ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.worktodo_updategroupenabled(boolean, integer);
CREATE OR REPLACE FUNCTION public.worktodo_updategroupenabled(
    IN enabled boolean,
    IN groupno integer
) RETURNS void
AS $function$
BEGIN
 

	Update WorkToDo_Groups set Enabled=worktodo_updategroupenabled.enabled where GroupNo=worktodo_updategroupenabled.groupno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
