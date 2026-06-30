-- ─── PROCEDURE→FUNCTION: organization_insertuser ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.organization_insertuser(integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer, character varying, character varying, character varying, boolean, character varying, character varying, boolean, timestamp without time zone, timestamp without time zone, timestamp without time zone, integer);
CREATE OR REPLACE FUNCTION public.organization_insertuser(
    IN moduserno integer,
    IN userid character varying,
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
    IN userphoto boolean,
    IN photo character varying,
    IN timezone character varying,
    IN enabled boolean,
    IN moddate timestamp without time zone DEFAULT NULL,
    IN entrancedate timestamp without time zone DEFAULT NULL,
    IN birthdate timestamp without time zone DEFAULT NULL,
    IN birthdatetype integer DEFAULT 0
) RETURNS SETOF record
AS $function$
DECLARE
    userno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO Organization_Users (ModUserNo, ModDate,
		UserID, Password, PasswordChangeDate, Name, Name_EN, MailAddress, Sex, CellPhone,
		CompanyPhone, ExtensionNumber, EntranceDate, BirthDate, BirthDateType,UserPhoto, Photo, TimeZone, Enabled, IsVirtual
		,Name_CH,Name_JP,Name_VN)
	VALUES (ModUserNo, ModDate,
		UserID, Password, ModDate, Name, Name_EN, MailAddress, Sex, CellPhone,
		CompanyPhone, ExtensionNumber, EntranceDate, BirthDate, BirthDateType,UserPhoto, Photo, TimeZone, Enabled, 0
		,Name_CH,Name_JP,Name_VN)


	UserNo := lastval();
	IF (SELECT COUNT(*) FROM Center_Applications WHERE ProjectCode = 'Mail') > 0 AND UserID != '' THEN

		PERFORM mail_insertnewaccount(UserNo, ModUserNo

	END IF;

	SELECT UserNo);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
