-- ─── PROCEDURE→FUNCTION: organization_updatedepartmentenabled ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.organization_updatedepartmentenabled(integer, integer, timestamp without time zone, boolean);
CREATE OR REPLACE FUNCTION public.organization_updatedepartmentenabled(
    IN departno integer,
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN enabled boolean
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
