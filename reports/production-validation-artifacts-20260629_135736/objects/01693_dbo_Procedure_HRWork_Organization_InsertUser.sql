-- ─── PROCEDURE→FUNCTION: hrwork_organization_insertuser ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.hrwork_organization_insertuser(character varying, integer, character varying, character varying, character varying, character varying, character varying, timestamp without time zone, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.hrwork_organization_insertuser(
    IN userid character varying,
    IN positionno integer,
    IN password character varying,
    IN name character varying,
    IN mailaddress character varying,
    IN cellphone character varying,
    IN companyphone character varying,
    IN entrancedate timestamp without time zone,
    IN birthdate timestamp without time zone
) RETURNS SETOF record
AS $function$
DECLARE
    userno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO Organization_Users (ModUserNo, ModDate,
		UserID, Password, PasswordChangeDate, Name, Name_EN, MailAddress, Sex, CellPhone,
		CompanyPhone, ExtensionNumber, EntranceDate, BirthDate, UserPhoto, Photo, TimeZone, Enabled, IsVirtual
		,Name_CH,Name_JP,Name_VN)
	VALUES (0, NOW(),
		UserID, Password, NOW(), Name, '', MailAddress, 0, CellPhone,
		CompanyPhone, '', EntranceDate, BirthDate, 0, '', 'Korea Standard Time', 1, 0
		,'','','')


	UserNo := lastval();
	IF (SELECT COUNT(*) FROM Center_Applications WHERE ProjectCode = 'Mail') > 0 AND UserID != '' THEN

		EXEC Mail_InsertNewAccount UserNo, 0

	END IF;

	INSERT INTO Organization_BelongToDepartment(UserNo,DepartNo,PositionNo,DutyNo,IsDefault)
	values(UserNo,1,PositionNo,1,1);

	RETURN QUERY
	SELECT UserNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
