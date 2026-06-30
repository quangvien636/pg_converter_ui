-- ─── FUNCTION: organization_updatedepartmentenabled ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_updatedepartmentenabled(integer, integer, timestamp without time zone, boolean);
CREATE OR REPLACE FUNCTION public.organization_updatedepartmentenabled(
    departno integer,
    moduserno integer,
    moddate timestamp without time zone,
    enabled boolean
) RETURNS void
AS $function$
BEGIN


	UPDATE Departments SET
		ModUserNo = organization_updatedepartmentenabled.moduserno,
		ModDate = organization_updatedepartmentenabled.moddate,
		Enabled = organization_updatedepartmentenabled.enabled
	WHERE DepartNo = organization_updatedepartmentenabled.departno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
