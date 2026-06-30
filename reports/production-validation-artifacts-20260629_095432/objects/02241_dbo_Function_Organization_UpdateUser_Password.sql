-- ─── FUNCTION: organization_updateuser_password ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_updateuser_password(integer, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.organization_updateuser_password(
    userno integer,
    moduserno integer,
    moddate timestamp without time zone
) RETURNS void
AS $function$
BEGIN


	IF (select count(*) from Center_CompanyInformation where value = 'ngw.pncport.com' and Key = 'Company_Domain') = 0 
	BEGIN;
			DELETE FROM Center_Sessions WHERE UserNo = organization_updateuser_password.userno;
			DELETE FROM Center_MobileSessions WHERE UserNo = organization_updateuser_password.userno
	END


	UPDATE Organization_Users SET
		ModUserNo = organization_updateuser_password.moduserno,
		ModDate = organization_updateuser_password.moddate,
		Password = Password,
		PasswordChangeDate = organization_updateuser_password.moddate
	WHERE UserNo = organization_updateuser_password.userno
	
	IF (SELECT COUNT(*) FROM Center_Applications WHERE ProjectCode = 'Mail') > 0 BEGIN;
		UPDATE Mail_Accounts SET PopPwd = Password WHERE UserNo = organization_updateuser_password.userno
		and Server in (select ServerHost from Mail_Servers)
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
