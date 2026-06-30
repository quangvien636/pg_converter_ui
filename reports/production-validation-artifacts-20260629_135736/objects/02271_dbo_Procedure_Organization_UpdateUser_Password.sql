-- ─── PROCEDURE→FUNCTION: organization_updateuser_password ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.organization_updateuser_password(integer, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.organization_updateuser_password(
    IN userno integer,
    IN moduserno integer,
    IN moddate timestamp without time zone
) RETURNS void
AS $function$
BEGIN


	IF (select count(*) from Center_CompanyInformation where value = 'ngw.pncport.com' and Key = 'Company_Domain') = 0 THEN;
			DELETE FROM Center_Sessions WHERE UserNo = organization_updateuser_password.userno;
			DELETE FROM Center_MobileSessions WHERE UserNo = organization_updateuser_password.userno
	END IF;


	UPDATE Organization_Users SET
		ModUserNo = organization_updateuser_password.moduserno,
		ModDate = organization_updateuser_password.moddate,
		Password = Password,
		PasswordChangeDate = organization_updateuser_password.moddate
	WHERE UserNo = organization_updateuser_password.userno
	
	IF (SELECT COUNT(*) FROM Center_Applications WHERE ProjectCode = 'Mail') > 0 THEN;
		UPDATE Mail_Accounts SET PopPwd = Password WHERE UserNo = organization_updateuser_password.userno
		and Server in (select ServerHost from Mail_Servers)
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
