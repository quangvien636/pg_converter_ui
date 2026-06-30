-- ─── PROCEDURE→FUNCTION: mail_updatemailtemplatecategory_sortno ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.mail_updatemailtemplatecategory_sortno(integer, boolean);
CREATE OR REPLACE FUNCTION public.mail_updatemailtemplatecategory_sortno(
    IN categoryno integer,
    IN isup boolean
) RETURNS void
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	
	TopSortNo := (SELECT /* TOP 1 */ SortNo FROM Mail_MailTemplateCategories ORDER BY SortNo DESC);
	_SortNo := (SELECT SortNo FROM Mail_MailTemplateCategories WHERE CategoryNo = mail_updatemailtemplatecategory_sortno.categoryno);
	IF IsUp = TRUE THEN
	
		IF _SortNo != 1 THEN
		
			_CategoryNo := (SELECT CategoryNo FROM Mail_MailTemplateCategories WHERE SortNo = _SortNo - 1);;
			UPDATE Mail_MailTemplateCategories SET SortNo = _SortNo WHERE CategoryNo = _CategoryNo			;
			UPDATE Mail_MailTemplateCategories SET SortNo = _SortNo - 1 WHERE CategoryNo = mail_updatemailtemplatecategory_sortno.categoryno
		
		END IF;

	END IF;
	
	ELSE BEGIN
	
		IF _SortNo != TopSortNo THEN
		
			_CategoryNo := (SELECT CategoryNo FROM Mail_MailTemplateCategories WHERE SortNo = _SortNo + 1);;
			UPDATE Mail_MailTemplateCategories SET SortNo = _SortNo WHERE CategoryNo = _CategoryNo			;
			UPDATE Mail_MailTemplateCategories SET SortNo = _SortNo + 1 WHERE CategoryNo = mail_updatemailtemplatecategory_sortno.categoryno
		
		END IF;
		
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
