-- ─── PROCEDURE→FUNCTION: organization_updatedepartment_shortname ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.organization_updatedepartment_shortname(integer, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.organization_updatedepartment_shortname(
    IN departno integer,
    IN moduserno integer,
    IN moddate timestamp without time zone
) RETURNS void
AS $function$
BEGIN


	UPDATE Organization_Departments SET
		ModUserNo = organization_updatedepartment_shortname.moduserno,
		ModDate = organization_updatedepartment_shortname.moddate,
		ShortName = ShortName
	WHERE DepartNo = organization_updatedepartment_shortname.departno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
