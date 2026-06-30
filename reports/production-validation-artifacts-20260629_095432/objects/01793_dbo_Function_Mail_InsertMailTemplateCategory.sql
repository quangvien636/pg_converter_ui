-- ─── FUNCTION: mail_insertmailtemplatecategory ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_insertmailtemplatecategory();
CREATE OR REPLACE FUNCTION public.mail_insertmailtemplatecategory(
) RETURNS TABLE(
    col1 text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
DECLARE
    categoryno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO Mail_MailTemplateCategories (Name, SortNo, Enabled)
	VALUES (Name, COALESCE((SELECT /* TOP 1 */ SortNo + 1 FROM Mail_MailTemplateCategories ORDER BY SortNo DESC), 0), 1)
	

	SET CategoryNo = lastval()
	
	RETURN QUERY
	SELECT CategoryNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
