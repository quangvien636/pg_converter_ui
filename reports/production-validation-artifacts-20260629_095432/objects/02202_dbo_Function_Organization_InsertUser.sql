-- ─── FUNCTION: organization_insertuser ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_insertuser(integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer, character varying, character varying, character varying, boolean, character varying, character varying, boolean, timestamp without time zone, timestamp without time zone, timestamp without time zone, integer);
CREATE OR REPLACE FUNCTION public.organization_insertuser(
    moduserno integer,
    userid character varying,
    password character varying,
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
    userphoto boolean,
    photo character varying,
    timezone character varying,
    enabled boolean,
    moddate timestamp without time zone DEFAULT NULL,
    entrancedate timestamp without time zone DEFAULT NULL,
    birthdate timestamp without time zone DEFAULT NULL,
    birthdatetype integer DEFAULT 0
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    userno integer;
BEGIN


	INSERT INTO Organization_Users (ModUserNo, ModDate,
		UserID, Password, PasswordChangeDate, Name, Name_EN, MailAddress, Sex, CellPhone,
		CompanyPhone, ExtensionNumber, EntranceDate, BirthDate, BirthDateType,UserPhoto, Photo, TimeZone, Enabled, IsVirtual
		,Name_CH,Name_JP,Name_VN)
	VALUES (ModUserNo, ModDate,
		UserID, Password, ModDate, Name, Name_EN, MailAddress, Sex, CellPhone,
		CompanyPhone, ExtensionNumber, EntranceDate, BirthDate, BirthDateType,UserPhoto, Photo, TimeZone, Enabled, 0
		,Name_CH,Name_JP,Name_VN)


	SET UserNo = lastval()
	
	IF (SELECT COUNT(*) FROM Center_Applications WHERE ProjectCode = 'Mail') > 0 AND UserID != '' BEGIN

		EXEC Mail_InsertNewAccount UserNo, ModUserNo

	END

	RETURN QUERY
	SELECT UserNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
