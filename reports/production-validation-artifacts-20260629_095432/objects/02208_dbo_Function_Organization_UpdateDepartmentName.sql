-- ─── FUNCTION: organization_updatedepartmentname ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_updatedepartmentname(integer, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.organization_updatedepartmentname(
    departno integer,
    moduserno integer,
    moddate timestamp without time zone
) RETURNS void
AS $function$
BEGIN


	UPDATE Departments SET
		ModUserNo = organization_updatedepartmentname.moduserno,
		ModDate = organization_updatedepartmentname.moddate,
		Name = Name
	WHERE DepartNo = organization_updatedepartmentname.departno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
