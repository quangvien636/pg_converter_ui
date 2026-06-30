-- ─── FUNCTION: organization_updatedepartment_name_en ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_updatedepartment_name_en(integer, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.organization_updatedepartment_name_en(
    departno integer,
    moduserno integer,
    moddate timestamp without time zone
) RETURNS void
AS $function$
BEGIN


	UPDATE Organization_Departments SET
		ModUserNo = organization_updatedepartment_name_en.moduserno,
		ModDate = organization_updatedepartment_name_en.moddate,
		Name_EN = Name_EN
	WHERE DepartNo = organization_updatedepartment_name_en.departno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
