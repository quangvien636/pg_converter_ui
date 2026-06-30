-- ─── PROCEDURE→FUNCTION: note_getdepartments ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.note_getdepartments(integer);
CREATE OR REPLACE FUNCTION public.note_getdepartments(
    IN parentno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	IF ParentNo=-1 THEN
			RETURN QUERY
			SELECT * FROM Organization_Departments
			WHERE Enabled = TRUE

		END IF;
	ELSE
		RETURN QUERY
		SELECT * FROM Organization_Departments
	WHERE ParentNo=note_getdepartments.parentno AND Enabled = TRUE

	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
