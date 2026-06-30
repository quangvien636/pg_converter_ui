-- ─── FUNCTION: mail_getmailtemplate ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_getmailtemplate(integer);
CREATE OR REPLACE FUNCTION public.mail_getmailtemplate(
    templateno integer
) RETURNS TABLE(
    templateno text,
    moduserno text,
    moddate text,
    categoryno text,
    name text,
    content text,
    enabled text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT TemplateNo, ModUserNo, ModDate, CategoryNo, Name, Content, Enabled
	FROM Mail_MailTemplates 
	WHERE TemplateNo = mail_getmailtemplate.templateno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
