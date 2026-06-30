-- ─── PROCEDURE→FUNCTION: mail_deletemailtemplatecategory ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.mail_deletemailtemplatecategory(integer);
CREATE OR REPLACE FUNCTION public.mail_deletemailtemplatecategory(
    IN categoryno integer
) RETURNS void
AS $function$
DECLARE
    _sortno integer;
BEGIN



	_SortNo := (SELECT SortNo FROM Mail_MailTemplateCategories WHERE CategoryNo = mail_deletemailtemplatecategory.categoryno);;
	DELETE FROM Mail_MailTemplateCategories
	WHERE CategoryNo = mail_deletemailtemplatecategory.categoryno
	
	UPDATE Mail_MailTemplateCategories SET SortNo = SortNo - 1
	WHERE SortNo > _SortNo
	
	UPDATE Mail_MailTemplates SET CategoryNo = 0 WHERE CategoryNo = mail_deletemailtemplatecategory.categoryno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
