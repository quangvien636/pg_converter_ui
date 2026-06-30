-- ─── PROCEDURE→FUNCTION: mail_getmailtemplate ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.mail_getmailtemplate(integer);
CREATE OR REPLACE FUNCTION public.mail_getmailtemplate(
    IN templateno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT TemplateNo, ModUserNo, ModDate, CategoryNo, Name, Content, Enabled
	FROM Mail_MailTemplates 
	WHERE TemplateNo = mail_getmailtemplate.templateno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
