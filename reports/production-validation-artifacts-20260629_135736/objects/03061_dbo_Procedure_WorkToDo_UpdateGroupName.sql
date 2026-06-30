-- ─── PROCEDURE→FUNCTION: worktodo_updategroupname ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.worktodo_updategroupname(character varying, integer);
CREATE OR REPLACE FUNCTION public.worktodo_updategroupname(
    IN name character varying,
    IN groupno integer
) RETURNS void
AS $function$
BEGIN
 

	Update WorkToDo_Groups set Name=worktodo_updategroupname.name where GroupNo=worktodo_updategroupname.groupno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
