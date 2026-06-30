-- ─── FUNCTION: mail_getmailtemplatecategories ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_getmailtemplatecategories();
CREATE OR REPLACE FUNCTION public.mail_getmailtemplatecategories(
) RETURNS TABLE(
    categoryno text,
    name text,
    sortno text,
    enabled text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT CategoryNo, Name, SortNo, Enabled
	FROM Mail_MailTemplateCategories
	ORDER BY SortNo ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
