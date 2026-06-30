-- ─── FUNCTION: organization_updatedepartment_names ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_updatedepartment_names(integer, integer, timestamp without time zone, character varying, character varying, character varying, character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.organization_updatedepartment_names(
    departno integer,
    moduserno integer,
    moddate timestamp without time zone,
    name character varying,
    name_en character varying,
    name_ch character varying,
    name_jp character varying,
    name_vn character varying,
    shortname character varying,
    sendername character varying DEFAULT ''
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
