-- ─── PROCEDURE→FUNCTION: organization_updateuser ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.organization_updateuser(integer, integer, timestamp without time zone, character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer, character varying, character varying, character varying, date, integer, date, boolean, character varying);
CREATE OR REPLACE FUNCTION public.organization_updateuser(
    IN userno integer,
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN password character varying,
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
    IN entrancedate date,
    IN birthdatetype integer,
    IN birthdate date,
    IN userphoto boolean,
    IN photo character varying
) RETURNS void
AS $function$
BEGIN


	IF (SELECT COUNT(*) FROM Center_Applications WHERE ProjectCode = 'Mail') > 0 THEN;
		UPDATE Mail_Accounts SET PopPwd = organization_updateuser.password WHERE UserNo = organization_updateuser.userno
		and Server in (select ServerHost from Mail_Servers)
	END IF;


	UPDATE Organization_Users SET
		ModUserNo = organization_updateuser.moduserno,
		ModDate = organization_updateuser.moddate,
		Password = organization_updateuser.password,
		Name = organization_updateuser.name,
		Name_EN = organization_updateuser.name_en,
		Name_CH = organization_updateuser.name_ch,
		Name_JP = organization_updateuser.name_jp,
		Name_VN = organization_updateuser.name_vn,
		MailAddress = organization_updateuser.mailaddress,
		Sex = organization_updateuser.sex,
		CellPhone = organization_updateuser.cellphone,
		CompanyPhone = organization_updateuser.companyphone,
		ExtensionNumber = organization_updateuser.extensionnumber,
		EntranceDate = organization_updateuser.entrancedate,
		BirthDate = organization_updateuser.birthdate,
		BirthDateType = organization_updateuser.birthdatetype,
		UserPhoto = organization_updateuser.userphoto,
		Photo = organization_updateuser.photo,
		TimeZone = TimeZone
	WHERE UserNo = organization_updateuser.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
