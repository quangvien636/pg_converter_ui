-- ─── FUNCTION: organization_updatedepartment_name_vn ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_updatedepartment_name_vn(integer, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.organization_updatedepartment_name_vn(
    departno integer,
    moduserno integer,
    moddate timestamp without time zone
) RETURNS void
AS $function$
BEGIN


	UPDATE Organization_Departments SET
		ModUserNo = organization_updatedepartment_name_vn.moduserno,
		ModDate = organization_updatedepartment_name_vn.moddate,
		Name_VN = Name_VN
	WHERE DepartNo = organization_updatedepartment_name_vn.departno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
