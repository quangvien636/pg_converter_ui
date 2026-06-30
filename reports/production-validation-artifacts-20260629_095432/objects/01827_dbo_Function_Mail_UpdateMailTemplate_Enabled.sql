-- ─── FUNCTION: mail_updatemailtemplate_enabled ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_updatemailtemplate_enabled(integer, boolean);
CREATE OR REPLACE FUNCTION public.mail_updatemailtemplate_enabled(
    templateno integer,
    enabled boolean
) RETURNS void
AS $function$
BEGIN


	UPDATE Mail_MailTemplates SET Enabled = mail_updatemailtemplate_enabled.enabled
	WHERE TemplateNo = mail_updatemailtemplate_enabled.templateno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
