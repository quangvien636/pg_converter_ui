-- ─── FUNCTION: organization_updatedepartment_name_jp ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_updatedepartment_name_jp(integer, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.organization_updatedepartment_name_jp(
    departno integer,
    moduserno integer,
    moddate timestamp without time zone
) RETURNS void
AS $function$
BEGIN


	UPDATE Organization_Departments SET
		ModUserNo = organization_updatedepartment_name_jp.moduserno,
		ModDate = organization_updatedepartment_name_jp.moddate,
		Name_JP = Name_JP
	WHERE DepartNo = organization_updatedepartment_name_jp.departno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
