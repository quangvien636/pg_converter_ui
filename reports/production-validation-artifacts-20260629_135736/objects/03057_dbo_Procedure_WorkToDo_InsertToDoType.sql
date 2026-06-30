-- ─── PROCEDURE→FUNCTION: worktodo_inserttodotype ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.worktodo_inserttodotype(integer, timestamp without time zone, character varying, integer, boolean);
CREATE OR REPLACE FUNCTION public.worktodo_inserttodotype(
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN title character varying,
    IN sortno integer,
    IN enabled boolean
) RETURNS void
AS $function$
BEGIN

	INSERT INTO WorkToDo_ToDoTypes(ModUserNo,ModDate,Title,SortNo,Enabled)
	 VALUES(ModUserNo,ModDate,Title,SortNo,Enabled);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
