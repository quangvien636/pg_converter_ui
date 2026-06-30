-- ─── PROCEDURE→FUNCTION: mail_insertmailtemplate ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.mail_insertmailtemplate(integer, timestamp without time zone, integer, character varying, character varying, boolean);
CREATE OR REPLACE FUNCTION public.mail_insertmailtemplate(
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN categoryno integer,
    IN name character varying,
    IN content character varying,
    IN enabled boolean
) RETURNS SETOF record
AS $function$
DECLARE
    templateno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO Mail_MailTemplates (ModUserNo, ModDate, CategoryNo, Name, Content, Enabled)
	VALUES (ModUserNo, ModDate, CategoryNo, Name, Content, Enabled)
	

	TemplateNo := lastval();
	RETURN QUERY
	SELECT TemplateNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
