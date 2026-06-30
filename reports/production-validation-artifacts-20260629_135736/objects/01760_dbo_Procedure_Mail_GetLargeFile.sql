-- ─── PROCEDURE→FUNCTION: mail_getlargefile ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.mail_getlargefile(bigint);
CREATE OR REPLACE FUNCTION public.mail_getlargefile(
    IN fileno bigint
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT MailNo, Name, Size, ExpirationDate
	FROM Mail_MailLargeFiles
	WHERE FileNo = mail_getlargefile.fileno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
