-- ─── PROCEDURE→FUNCTION: mail_getmailaccounts ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.mail_getmailaccounts(integer);
CREATE OR REPLACE FUNCTION public.mail_getmailaccounts(
    IN userno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF UserNo = -1 THEN
	
		RETURN QUERY
		SELECT AccountNo, UserNo, ModUserNo, ModDate, Server, Port, PopUser, PopPwd,
			IsServerAccount, IsSharedAccount, IsDeleteEmlFile, IsWebMail, Name, MailAddress, Enabled
		FROM Mail_Accounts
		WHERE UserNo != -1
		ORDER BY IsServerAccount DESC, UserNo ASC
		
	END IF;

	ELSE BEGIN
	
		RETURN QUERY
		SELECT AccountNo, UserNo, ModUserNo, ModDate, Server, Port, PopUser, PopPwd,
			IsServerAccount, IsSharedAccount, IsDeleteEmlFile, IsWebMail, Name, MailAddress, Enabled
		FROM Mail_Accounts
		WHERE UserNo = mail_getmailaccounts.userno
		ORDER BY IsServerAccount DESC

	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
