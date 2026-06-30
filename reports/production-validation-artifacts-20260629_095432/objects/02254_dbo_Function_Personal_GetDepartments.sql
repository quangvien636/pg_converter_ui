-- ─── FUNCTION: personal_getdepartments ───────────────────────────────
DROP FUNCTION IF EXISTS public.personal_getdepartments();
CREATE OR REPLACE FUNCTION public.personal_getdepartments(
) RETURNS TABLE(
    departno text,
    name text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT DepartNo, Name From Departments
	WHERE Enabled = TRUE
	ORDER BY SortNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
