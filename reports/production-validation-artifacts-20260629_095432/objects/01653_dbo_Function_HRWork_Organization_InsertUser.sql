-- ─── FUNCTION: hrwork_organization_insertuser ───────────────────────────────
DROP FUNCTION IF EXISTS public.hrwork_organization_insertuser(character varying, integer, character varying, character varying, character varying, character varying, character varying, timestamp without time zone, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.hrwork_organization_insertuser(
    userid character varying,
    positionno integer,
    password character varying,
    name character varying,
    mailaddress character varying,
    cellphone character varying,
    companyphone character varying,
    entrancedate timestamp without time zone,
    birthdate timestamp without time zone
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    userno integer;
BEGIN


	INSERT INTO Organization_Users (ModUserNo, ModDate,
		UserID, Password, PasswordChangeDate, Name, Name_EN, MailAddress, Sex, CellPhone,
		CompanyPhone, ExtensionNumber, EntranceDate, BirthDate, UserPhoto, Photo, TimeZone, Enabled, IsVirtual
		,Name_CH,Name_JP,Name_VN)
	VALUES (0, NOW(),
		UserID, Password, NOW(), Name, '', MailAddress, 0, CellPhone,
		CompanyPhone, '', EntranceDate, BirthDate, 0, '', 'Korea Standard Time', 1, 0
		,'','','')


	SET UserNo = lastval()
	
	IF (SELECT COUNT(*) FROM Center_Applications WHERE ProjectCode = 'Mail') > 0 AND UserID != '' BEGIN

		EXEC Mail_InsertNewAccount UserNo, 0

	END

	INSERT INTO Organization_BelongToDepartment(UserNo,DepartNo,PositionNo,DutyNo,IsDefault)
	values(UserNo,1,PositionNo,1,1);

	RETURN QUERY
	SELECT UserNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
