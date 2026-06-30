-- ─── PROCEDURE→FUNCTION: worktodo_updatetodotype_enabled ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.worktodo_updatetodotype_enabled(integer, timestamp without time zone, boolean);
CREATE OR REPLACE FUNCTION public.worktodo_updatetodotype_enabled(
    IN typeno integer,
    IN moddate timestamp without time zone,
    IN enabled boolean
) RETURNS void
AS $function$
BEGIN

	UPDATE WorkToDo_ToDoTypes SET
		ModDate = worktodo_updatetodotype_enabled.moddate,
		Enabled = worktodo_updatetodotype_enabled.enabled
	WHERE TypeNo = worktodo_updatetodotype_enabled.typeno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
