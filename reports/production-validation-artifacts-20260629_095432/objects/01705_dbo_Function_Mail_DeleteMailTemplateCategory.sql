-- ─── FUNCTION: mail_deletemailtemplatecategory ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_deletemailtemplatecategory(integer);
CREATE OR REPLACE FUNCTION public.mail_deletemailtemplatecategory(
    categoryno integer
) RETURNS void
AS $function$
DECLARE
    _sortno integer;
BEGIN



	SET _SortNo = (SELECT SortNo FROM Mail_MailTemplateCategories WHERE CategoryNo = mail_deletemailtemplatecategory.categoryno)

	DELETE FROM Mail_MailTemplateCategories
	WHERE CategoryNo = mail_deletemailtemplatecategory.categoryno
	
	UPDATE Mail_MailTemplateCategories SET SortNo = SortNo - 1
	WHERE SortNo > _SortNo
	
	UPDATE Mail_MailTemplates SET CategoryNo = 0 WHERE CategoryNo = mail_deletemailtemplatecategory.categoryno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
