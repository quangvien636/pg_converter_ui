-- ─── FUNCTION: mail_deletemailtemplate ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_deletemailtemplate(integer);
CREATE OR REPLACE FUNCTION public.mail_deletemailtemplate(
    templateno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM Mail_MailTemplates WHERE TemplateNo = mail_deletemailtemplate.templateno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
