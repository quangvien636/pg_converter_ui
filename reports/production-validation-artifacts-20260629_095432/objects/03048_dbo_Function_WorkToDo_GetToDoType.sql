-- ─── FUNCTION: worktodo_gettodotype ───────────────────────────────
DROP FUNCTION IF EXISTS public.worktodo_gettodotype(integer);
CREATE OR REPLACE FUNCTION public.worktodo_gettodotype(
    typeno integer
) RETURNS TABLE(
    moduserno text,
    moddate text,
    title text,
    sortno text,
    enabled text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT ModUserNo, ModDate, Title, SortNo, Enabled
	FROM WorkToDo_ToDoTypes WHERE TypeNo = worktodo_gettodotype.typeno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
