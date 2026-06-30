-- ─── FUNCTION: organization_updatedepartment_name_ch ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_updatedepartment_name_ch(integer, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.organization_updatedepartment_name_ch(
    departno integer,
    moduserno integer,
    moddate timestamp without time zone
) RETURNS void
AS $function$
BEGIN


	UPDATE Organization_Departments SET
		ModUserNo = organization_updatedepartment_name_ch.moduserno,
		ModDate = organization_updatedepartment_name_ch.moddate,
		Name_CH = Name_CH
	WHERE DepartNo = organization_updatedepartment_name_ch.departno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
