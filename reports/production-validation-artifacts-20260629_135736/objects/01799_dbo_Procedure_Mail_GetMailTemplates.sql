-- ─── PROCEDURE→FUNCTION: mail_getmailtemplates ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.mail_getmailtemplates(integer, boolean);
CREATE OR REPLACE FUNCTION public.mail_getmailtemplates(
    IN categoryno integer,
    IN asdisabled boolean
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF CategoryNo = -1 THEN
	
		IF AsDisabled = 1 THEN
		
			RETURN QUERY
			SELECT T.TemplateNo, T.ModUserNo, T.ModDate, T.CategoryNo, COALESCE(C.Name, '') AS CategoryName, T.Name, T.Enabled
			FROM Mail_MailTemplates T
			LEFT JOIN Mail_MailTemplateCategories C ON C.CategoryNo = T.CategoryNo
		
		END IF;
	
		ELSE BEGIN
		
			RETURN QUERY
			SELECT T.TemplateNo, T.ModUserNo, T.ModDate, T.CategoryNo, COALESCE(C.Name, '') AS CategoryName, T.Name, T.Enabled
			FROM Mail_MailTemplates T
			LEFT JOIN Mail_MailTemplateCategories C ON C.CategoryNo = T.CategoryNo
			WHERE T.Enabled = TRUE
		
		END IF;
		
	END;
	
	ELSE BEGIN
	
		IF AsDisabled = 1 THEN
		
			RETURN QUERY
			SELECT T.TemplateNo, T.ModUserNo, T.ModDate, T.CategoryNo, COALESCE(C.Name, '') AS CategoryName, T.Name, T.Enabled
			FROM Mail_MailTemplates T
			LEFT JOIN Mail_MailTemplateCategories C ON C.CategoryNo = T.CategoryNo
			WHERE T.CategoryNo = mail_getmailtemplates.categoryno
		
		END IF;
	
		ELSE BEGIN
		
			RETURN QUERY
			SELECT T.TemplateNo, T.ModUserNo, T.ModDate, T.CategoryNo, COALESCE(C.Name, '') AS CategoryName, T.Name, T.Enabled
			FROM Mail_MailTemplates T
			LEFT JOIN Mail_MailTemplateCategories C ON C.CategoryNo = T.CategoryNo
			WHERE T.Enabled = TRUE AND T.CategoryNo = mail_getmailtemplates.categoryno
		
		END;
	
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
