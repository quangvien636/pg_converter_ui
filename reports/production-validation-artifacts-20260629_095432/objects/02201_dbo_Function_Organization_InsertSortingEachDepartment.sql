-- ─── FUNCTION: organization_insertsortingeachdepartment ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_insertsortingeachdepartment(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.organization_insertsortingeachdepartment(
    departno integer,
    userno integer,
    sortno integer
) RETURNS TABLE(
    datano text
)
AS $function$
DECLARE
    datano bigint;
BEGIN


	INSERT INTO Organization_SortingEachDepartment VALUES (DepartNo, UserNo, SortNo)
	

	SET DataNo = lastval()

	RETURN QUERY
	SELECT DataNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
