-- ─── FUNCTION: worktodo_inserttodotype ───────────────────────────────
DROP FUNCTION IF EXISTS public.worktodo_inserttodotype(integer, timestamp without time zone, character varying, integer, boolean);
CREATE OR REPLACE FUNCTION public.worktodo_inserttodotype(
    moduserno integer,
    moddate timestamp without time zone,
    title character varying,
    sortno integer,
    enabled boolean
) RETURNS void
AS $function$
BEGIN

	INSERT INTO WorkToDo_ToDoTypes(ModUserNo,ModDate,Title,SortNo,Enabled)
	 VALUES(ModUserNo,ModDate,Title,SortNo,Enabled);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
