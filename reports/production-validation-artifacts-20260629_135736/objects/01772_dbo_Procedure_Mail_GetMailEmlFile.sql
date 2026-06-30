-- ─── PROCEDURE→FUNCTION: mail_getmailemlfile ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.mail_getmailemlfile(bigint);
CREATE OR REPLACE FUNCTION public.mail_getmailemlfile(
    IN mailno bigint
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT MailNo, P.PopUser, M.ToDomain, EmlFileName
	FROM Mail_Mails M
	INNER JOIN Mail_Accounts P ON P.AccountNo = M.AccNo
	WHERE M.MailNo = mail_getmailemlfile.mailno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
