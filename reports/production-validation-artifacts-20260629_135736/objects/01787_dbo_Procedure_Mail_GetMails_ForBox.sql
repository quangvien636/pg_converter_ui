-- ─── PROCEDURE→FUNCTION: mail_getmails_forbox ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.mail_getmails_forbox(bigint);
CREATE OR REPLACE FUNCTION public.mail_getmails_forbox(
    IN boxno bigint
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT MailNo
	FROM Mail_Mails
	WHERE BoxNo = mail_getmails_forbox.boxno AND IsDelete = FALSE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
