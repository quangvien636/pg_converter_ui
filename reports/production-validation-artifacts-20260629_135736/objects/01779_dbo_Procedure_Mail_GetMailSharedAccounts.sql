-- ─── PROCEDURE→FUNCTION: mail_getmailsharedaccounts ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.mail_getmailsharedaccounts();
CREATE OR REPLACE FUNCTION public.mail_getmailsharedaccounts(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT AccountNo, UserNo, ModUserNo, ModDate, Server, Port, PopUser, PopPwd,
		IsServerAccount, IsSharedAccount, IsDeleteEmlFile, IsWebMail, Name, MailAddress, Enabled
	FROM Mail_Accounts
	WHERE IsSharedAccount = TRUE
	ORDER BY AccountNo ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
