-- ─── FUNCTION: organization_getcountofsortingeachdepartment ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_getcountofsortingeachdepartment(integer);
CREATE OR REPLACE FUNCTION public.organization_getcountofsortingeachdepartment(
    departno integer
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    count integer;
BEGIN



	SET Count = (SELECT COUNT(*) FROM Organization_SortingEachDepartment WHERE DepartNo = organization_getcountofsortingeachdepartment.departno)

	RETURN QUERY
	SELECT COALESCE(Count, 0);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
