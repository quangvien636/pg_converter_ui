-- ─── FUNCTION: organization_updatedepartment_sortno ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_updatedepartment_sortno(integer, integer, timestamp without time zone, integer);
CREATE OR REPLACE FUNCTION public.organization_updatedepartment_sortno(
    departno integer,
    moduserno integer,
    moddate timestamp without time zone,
    sortno integer
) RETURNS void
AS $function$
BEGIN


	UPDATE Organization_Departments SET
		ModUserNo = organization_updatedepartment_sortno.moduserno,
		ModDate = organization_updatedepartment_sortno.moddate,
		SortNo = organization_updatedepartment_sortno.sortno
	WHERE DepartNo = organization_updatedepartment_sortno.departno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
