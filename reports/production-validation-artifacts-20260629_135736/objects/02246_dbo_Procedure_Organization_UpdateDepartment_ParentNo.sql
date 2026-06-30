-- ─── PROCEDURE→FUNCTION: organization_updatedepartment_parentno ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.organization_updatedepartment_parentno(integer, integer, timestamp without time zone, integer);
CREATE OR REPLACE FUNCTION public.organization_updatedepartment_parentno(
    IN departno integer,
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN parentno integer
) RETURNS void
AS $function$
BEGIN



	
	SELECT ParentNo INTO originalparentno FROM Organization_Departments
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
