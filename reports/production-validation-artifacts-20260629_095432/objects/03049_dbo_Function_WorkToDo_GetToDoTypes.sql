-- ─── FUNCTION: worktodo_gettodotypes ───────────────────────────────
DROP FUNCTION IF EXISTS public.worktodo_gettodotypes(boolean);
CREATE OR REPLACE FUNCTION public.worktodo_gettodotypes(
    alsodisabled boolean
) RETURNS TABLE(
    typeno text,
    moduserno text,
    moddate text,
    title text,
    sortno text,
    enabled text
)
AS $function$
BEGIN


	IF (AlsoDisabled = 1) BEGIN

		RETURN QUERY
		SELECT TypeNo, ModUserNo, ModDate, Title, SortNo, Enabled
		FROM WorkToDo_ToDoTypes
		ORDER BY SortNo ASC

	END

	ELSE BEGIN

		RETURN QUERY
		SELECT TypeNo, ModUserNo, ModDate, Title, SortNo, Enabled
		FROM WorkToDo_ToDoTypes
		WHERE Enabled = TRUE
		ORDER BY SortNo ASC

	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
