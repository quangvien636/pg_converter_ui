-- ─── PROCEDURE→FUNCTION: mail_updatemailtemplate ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.mail_updatemailtemplate(integer, integer, timestamp without time zone, integer, character varying, character varying, boolean);
CREATE OR REPLACE FUNCTION public.mail_updatemailtemplate(
    IN templateno integer,
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN categoryno integer,
    IN name character varying,
    IN content character varying,
    IN enabled boolean
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
