-- ─── FUNCTION: organization_updatedepartment_name ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_updatedepartment_name(integer, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.organization_updatedepartment_name(
    departno integer,
    moduserno integer,
    moddate timestamp without time zone
) RETURNS void
AS $function$
BEGIN


	UPDATE Organization_Departments SET
		ModUserNo = organization_updatedepartment_name.moduserno,
		ModDate = organization_updatedepartment_name.moddate,
		Name = Name
	WHERE DepartNo = organization_updatedepartment_name.departno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
