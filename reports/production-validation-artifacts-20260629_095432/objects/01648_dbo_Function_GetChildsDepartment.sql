-- ─── FUNCTION: getchildsdepartment ───────────────────────────────
DROP FUNCTION IF EXISTS public.getchildsdepartment(integer);
CREATE OR REPLACE FUNCTION public.getchildsdepartment(
    pdepartno integer
) RETURNS TABLE(
    departno integer
)
AS $function$
#variable_conflict use_column
DECLARE
    level integer;
    stack table  (child_departno int);
BEGIN
	


	INSERT INTO ChildTree (DepartNo)
	RETURN QUERY
	SELECT DepartNo FROM Organization_Departments WHERE ParentNo=getchildsdepartment.pdepartno AND Enabled = TRUE
	
	return;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
