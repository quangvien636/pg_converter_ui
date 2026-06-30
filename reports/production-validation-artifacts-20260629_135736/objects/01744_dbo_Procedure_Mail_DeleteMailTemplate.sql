-- ─── PROCEDURE→FUNCTION: mail_deletemailtemplate ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.mail_deletemailtemplate(integer);
CREATE OR REPLACE FUNCTION public.mail_deletemailtemplate(
    IN templateno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM Mail_MailTemplates WHERE TemplateNo = mail_deletemailtemplate.templateno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
