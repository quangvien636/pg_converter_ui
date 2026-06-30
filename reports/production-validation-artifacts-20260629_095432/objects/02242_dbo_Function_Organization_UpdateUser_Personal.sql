-- ─── FUNCTION: organization_updateuser_personal ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_updateuser_personal(integer, integer, timestamp without time zone, character varying, character varying, character varying, character varying, character varying, character varying, integer, character varying, character varying, character varying, timestamp without time zone, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.organization_updateuser_personal(
    userno integer,
    moduserno integer,
    moddate timestamp without time zone,
    name character varying,
    name_en character varying,
    name_ch character varying,
    name_jp character varying,
    name_vn character varying,
    mailaddress character varying,
    sex integer,
    cellphone character varying,
    companyphone character varying,
    extensionnumber character varying,
    birthdate timestamp without time zone,
    birthdatetype integer,
    entrancedate timestamp without time zone
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

END


/************************************************** 2024-06-07 *****************************************************************/
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
