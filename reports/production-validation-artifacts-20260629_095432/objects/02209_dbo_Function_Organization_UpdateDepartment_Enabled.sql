-- ─── FUNCTION: organization_updatedepartment_enabled ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_updatedepartment_enabled(integer, integer, timestamp without time zone, boolean);
CREATE OR REPLACE FUNCTION public.organization_updatedepartment_enabled(
    departno integer,
    moduserno integer,
    moddate timestamp without time zone,
    enabled boolean
) RETURNS void
AS $function$
BEGIN


	UPDATE Organization_Departments SET
		ModUserNo = organization_updatedepartment_enabled.moduserno,
		ModDate = organization_updatedepartment_enabled.moddate,
		Enabled = organization_updatedepartment_enabled.enabled
	WHERE DepartNo = organization_updatedepartment_enabled.departno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
