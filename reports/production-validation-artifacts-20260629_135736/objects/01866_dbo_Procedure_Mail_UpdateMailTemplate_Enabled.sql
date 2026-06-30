-- ─── PROCEDURE→FUNCTION: mail_updatemailtemplate_enabled ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.mail_updatemailtemplate_enabled(integer, boolean);
CREATE OR REPLACE FUNCTION public.mail_updatemailtemplate_enabled(
    IN templateno integer,
    IN enabled boolean
) RETURNS void
AS $function$
BEGIN


	UPDATE Mail_MailTemplates SET Enabled = mail_updatemailtemplate_enabled.enabled
	WHERE TemplateNo = mail_updatemailtemplate_enabled.templateno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
