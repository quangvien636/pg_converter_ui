-- ─── FUNCTION: mail_insertmailtemplate ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_insertmailtemplate(integer, timestamp without time zone, integer, character varying, character varying, boolean);
CREATE OR REPLACE FUNCTION public.mail_insertmailtemplate(
    moduserno integer,
    moddate timestamp without time zone,
    categoryno integer,
    name character varying,
    content character varying,
    enabled boolean
) RETURNS TABLE(
    templateno text
)
AS $function$
DECLARE
    templateno integer;
BEGIN


	INSERT INTO Mail_MailTemplates (ModUserNo, ModDate, CategoryNo, Name, Content, Enabled)
	VALUES (ModUserNo, ModDate, CategoryNo, Name, Content, Enabled)
	

	SET TemplateNo = lastval()
	
	RETURN QUERY
	SELECT TemplateNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
