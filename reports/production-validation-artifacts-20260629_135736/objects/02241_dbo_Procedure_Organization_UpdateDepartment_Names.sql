-- ─── PROCEDURE→FUNCTION: organization_updatedepartment_names ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.organization_updatedepartment_names(integer, integer, timestamp without time zone, character varying, character varying, character varying, character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.organization_updatedepartment_names(
    IN departno integer,
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN name character varying,
    IN name_en character varying,
    IN name_ch character varying,
    IN name_jp character varying,
    IN name_vn character varying,
    IN shortname character varying,
    IN sendername character varying DEFAULT ''
) RETURNS void
AS $function$
BEGIN


	UPDATE Organization_Departments SET
		ModUserNo = organization_updatedepartment_names.moduserno,
		ModDate = organization_updatedepartment_names.moddate,
		Name = organization_updatedepartment_names.name,
		Name_EN = organization_updatedepartment_names.name_en,
		Name_CH = organization_updatedepartment_names.name_ch,
		Name_JP = organization_updatedepartment_names.name_jp,
		Name_VN = organization_updatedepartment_names.name_vn,
		ShortName = organization_updatedepartment_names.shortname,
		SenderName = organization_updatedepartment_names.sendername
	WHERE DepartNo = organization_updatedepartment_names.departno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
