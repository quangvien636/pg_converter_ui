-- ─── PROCEDURE→FUNCTION: worktodo_gettodotypes ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.worktodo_gettodotypes(boolean);
CREATE OR REPLACE FUNCTION public.worktodo_gettodotypes(
    IN alsodisabled boolean
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF AlsoDisabled = 1 THEN

		RETURN QUERY
		SELECT TypeNo, ModUserNo, ModDate, Title, SortNo, Enabled
		FROM WorkToDo_ToDoTypes
		ORDER BY SortNo ASC

	END IF;

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
