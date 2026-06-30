-- ─── FUNCTION: organization_updatedepartment_parentno ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_updatedepartment_parentno(integer, integer, timestamp without time zone, integer);
CREATE OR REPLACE FUNCTION public.organization_updatedepartment_parentno(
    departno integer,
    moduserno integer,
    moddate timestamp without time zone,
    parentno integer
) RETURNS void
AS $function$
BEGIN



	
	SELECT OriginalParentNo = organization_updatedepartment_parentno.parentno, OriginalSortNo = SortNo
	FROM Organization_Departments
	WHERE DepartNo = organization_updatedepartment_parentno.departno
	
	UPDATE Organization_Departments SET SortNo = SortNo - 1
	WHERE ParentNo = OriginalParentNo AND SortNo > OriginalSortNo
	
	UPDATE Organization_Departments SET SortNo = SortNo + 1
	WHERE ParentNo = organization_updatedepartment_parentno.parentno
	
	UPDATE Organization_Departments SET ParentNo = organization_updatedepartment_parentno.parentno, SortNo = 1
	WHERE DepartNo = organization_updatedepartment_parentno.departno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
