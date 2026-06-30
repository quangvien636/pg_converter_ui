-- ─── PROCEDURE→FUNCTION: organization_updateuser_personal ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.organization_updateuser_personal(integer, integer, timestamp without time zone, character varying, character varying, character varying, character varying, character varying, character varying, integer, character varying, character varying, character varying, timestamp without time zone, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.organization_updateuser_personal(
    IN userno integer,
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN name character varying,
    IN name_en character varying,
    IN name_ch character varying,
    IN name_jp character varying,
    IN name_vn character varying,
    IN mailaddress character varying,
    IN sex integer,
    IN cellphone character varying,
    IN companyphone character varying,
    IN extensionnumber character varying,
    IN birthdate timestamp without time zone,
    IN birthdatetype integer,
    IN entrancedate timestamp without time zone
) RETURNS void
AS $function$
BEGIN


	UPDATE Organization_Users SET
		ModUserNo = organization_updateuser_personal.moduserno,
		ModDate = organization_updateuser_personal.moddate,
		Name = organization_updateuser_personal.name,
		Name_EN = organization_updateuser_personal.name_en,
		Name_CH = organization_updateuser_personal.name_ch,
		Name_JP = organization_updateuser_personal.name_jp,
		Name_VN = organization_updateuser_personal.name_vn,
		MailAddress = organization_updateuser_personal.mailaddress,
		Sex = organization_updateuser_personal.sex,
		CellPhone = organization_updateuser_personal.cellphone,
		CompanyPhone = organization_updateuser_personal.companyphone,
		ExtensionNumber = organization_updateuser_personal.extensionnumber,
		BirthDate = organization_updateuser_personal.birthdate,
		BirthDateType = organization_updateuser_personal.birthdatetype,
		EntranceDate = organization_updateuser_personal.entrancedate
	WHERE UserNo = organization_updateuser_personal.userno

END;


/************************************************** 2024-06-07 *****************************************************************/
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
