-- ─── FUNCTION: organization_insertfirstmanager ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_insertfirstmanager(character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.organization_insertfirstmanager(
    userid character varying,
    password character varying,
    name character varying,
    name_en character varying
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    userno integer;
BEGIN


	INSERT INTO Organization_Users (ModUserNo, ModDate,
		UserID, Password, PasswordChangeDate, Name, Name_EN, MailAddress, Sex, CellPhone,
		 CompanyPhone, ExtensionNumber, EntranceDate, Birthdate, UserPhoto, Photo, TimeZone, Enabled, IsVirtual)
	VALUES (1, NOW(),
		UserID, Password, NOW(), Name, Name_EN, MailAddress, 1, '',
		'', '', NOW(), NOW(), 0, '', '', 1, 0)


	SET UserNo = lastval()
	


	SELECT PositionNo = MAX(PositionNo) FROM Organization_Positions WHERE Enabled = TRUE
	SELECT DutyNo = MAX(DutyNo) FROM Organization_Duties WHERE Enabled = TRUE
	
	INSERT INTO Organization_BelongToDepartment (UserNo, DepartNo, PositionNo, DutyNo, IsDefault)
	VALUES (1, 1, PositionNo, DutyNo, 1)

	INSERT INTO Authority_SitePermissions (UserNo, ModUserNo, ModDate, PermissionType)
	VALUES (1, 1, NOW(), 1)

	RETURN QUERY
	SELECT UserNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
