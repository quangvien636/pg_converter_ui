-- ─── PROCEDURE→FUNCTION: organization_insertfirstmanager ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.organization_insertfirstmanager(character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.organization_insertfirstmanager(
    IN userid character varying,
    IN password character varying,
    IN name character varying,
    IN name_en character varying
) RETURNS SETOF record
AS $function$
DECLARE
    userno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO Organization_Users (ModUserNo, ModDate,
		UserID, Password, PasswordChangeDate, Name, Name_EN, MailAddress, Sex, CellPhone,
		 CompanyPhone, ExtensionNumber, EntranceDate, Birthdate, UserPhoto, Photo, TimeZone, Enabled, IsVirtual)
	VALUES (1, NOW(),
		UserID, Password, NOW(), Name, Name_EN, MailAddress, 1, '',
		'', '', NOW(), NOW(), 0, '', '', 1, 0)


	UserNo := lastval();


	SELECT MAX(PositionNo) INTO positionno FROM Organization_Positions WHERE Enabled = TRUE
	SELECT MAX(DutyNo) INTO dutyno FROM Organization_Duties WHERE Enabled = TRUE
	
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
