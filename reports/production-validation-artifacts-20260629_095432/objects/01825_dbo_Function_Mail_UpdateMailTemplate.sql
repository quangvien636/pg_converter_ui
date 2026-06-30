-- ─── FUNCTION: mail_updatemailtemplate ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_updatemailtemplate(integer, integer, timestamp without time zone, integer, character varying, character varying, boolean);
CREATE OR REPLACE FUNCTION public.mail_updatemailtemplate(
    templateno integer,
    moduserno integer,
    moddate timestamp without time zone,
    categoryno integer,
    name character varying,
    content character varying,
    enabled boolean
) RETURNS void
AS $function$
BEGIN


	UPDATE Mail_MailTemplates SET
		ModUserNo = mail_updatemailtemplate.moduserno,
		ModDate = mail_updatemailtemplate.moddate,
		CategoryNo = mail_updatemailtemplate.categoryno,
		Name = mail_updatemailtemplate.name,
		Content = mail_updatemailtemplate.content,
		Enabled = mail_updatemailtemplate.enabled
	WHERE TemplateNo = mail_updatemailtemplate.templateno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
