-- ─── PROCEDURE→FUNCTION: mail_getfiles ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.mail_getfiles(bigint);
CREATE OR REPLACE FUNCTION public.mail_getfiles(
    IN mailno bigint
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT F.FileNo, M.MailNo, M.UserNo, M.IsSent, M.ToDomain, M.EmlFileName, F.Name, F.Size
	FROM Mail_MailFiles F 
	INNER JOIN Mail_Mails M ON M.MailNo = F.MailNo
	WHERE F.MailNo = mail_getfiles.mailno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
