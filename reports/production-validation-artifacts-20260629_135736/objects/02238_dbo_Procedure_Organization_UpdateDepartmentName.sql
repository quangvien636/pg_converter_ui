-- ─── PROCEDURE→FUNCTION: organization_updatedepartmentname ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.organization_updatedepartmentname(integer, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.organization_updatedepartmentname(
    IN departno integer,
    IN moduserno integer,
    IN moddate timestamp without time zone
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
