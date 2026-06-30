-- ─── PROCEDURE→FUNCTION: mail_getmailbccusermailaddress ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.mail_getmailbccusermailaddress(integer);
CREATE OR REPLACE FUNCTION public.mail_getmailbccusermailaddress(
    IN userno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

       
	RETURN QUERY
	select U.MailAddress,U.Name from Mail_BccSetting B
	INNER JOIN Organization_Users U ON B.UserNo = U.UserNo
	where BccUserNo = mail_getmailbccusermailaddress.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
