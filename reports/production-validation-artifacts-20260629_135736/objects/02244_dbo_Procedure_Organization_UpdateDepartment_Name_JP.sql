-- ─── PROCEDURE→FUNCTION: organization_updatedepartment_name_jp ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.organization_updatedepartment_name_jp(integer, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.organization_updatedepartment_name_jp(
    IN departno integer,
    IN moduserno integer,
    IN moddate timestamp without time zone
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
