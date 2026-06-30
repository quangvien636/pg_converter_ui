-- ─── FUNCTION: mail_getmailtemplates ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_getmailtemplates(integer, boolean);
CREATE OR REPLACE FUNCTION public.mail_getmailtemplates(
    categoryno integer,
    asdisabled boolean
) RETURNS TABLE(
    templateno text,
    moduserno text,
    moddate text,
    categoryno text,
    categoryname text,
    name text,
    enabled text
)
AS $function$
BEGIN


	IF (CategoryNo = -1) BEGIN
	
		IF (AsDisabled = 1) BEGIN
		
			RETURN QUERY
			SELECT T.TemplateNo, T.ModUserNo, T.ModDate, T.CategoryNo, COALESCE(C.Name, '') AS CategoryName, T.Name, T.Enabled
			FROM Mail_MailTemplates T
			LEFT JOIN Mail_MailTemplateCategories C ON C.CategoryNo = T.CategoryNo
		
		END 
	
		ELSE BEGIN
		
			RETURN QUERY
			SELECT T.TemplateNo, T.ModUserNo, T.ModDate, T.CategoryNo, COALESCE(C.Name, '') AS CategoryName, T.Name, T.Enabled
			FROM Mail_MailTemplates T
			LEFT JOIN Mail_MailTemplateCategories C ON C.CategoryNo = T.CategoryNo
			WHERE T.Enabled = TRUE
		
		END
		
	END
	
	ELSE BEGIN
	
		IF (AsDisabled = 1) BEGIN
		
			RETURN QUERY
			SELECT T.TemplateNo, T.ModUserNo, T.ModDate, T.CategoryNo, COALESCE(C.Name, '') AS CategoryName, T.Name, T.Enabled
			FROM Mail_MailTemplates T
			LEFT JOIN Mail_MailTemplateCategories C ON C.CategoryNo = T.CategoryNo
			WHERE T.CategoryNo = mail_getmailtemplates.categoryno
		
		END 
	
		ELSE BEGIN
		
			RETURN QUERY
			SELECT T.TemplateNo, T.ModUserNo, T.ModDate, T.CategoryNo, COALESCE(C.Name, '') AS CategoryName, T.Name, T.Enabled
			FROM Mail_MailTemplates T
			LEFT JOIN Mail_MailTemplateCategories C ON C.CategoryNo = T.CategoryNo
			WHERE T.Enabled = TRUE AND T.CategoryNo = mail_getmailtemplates.categoryno
		
		END
	
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
