-- ─── FUNCTION: mail_updatemailtemplatecategory_sortno ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_updatemailtemplatecategory_sortno(integer, boolean);
CREATE OR REPLACE FUNCTION public.mail_updatemailtemplatecategory_sortno(
    categoryno integer,
    isup boolean
) RETURNS void
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	
	SET TopSortNo = (SELECT /* TOP 1 */ SortNo FROM Mail_MailTemplateCategories ORDER BY SortNo DESC)
	SET _SortNo = (SELECT SortNo FROM Mail_MailTemplateCategories WHERE CategoryNo = mail_updatemailtemplatecategory_sortno.categoryno)
	
	IF (IsUp = TRUE) BEGIN
	
		IF (_SortNo != 1) BEGIN
		
			SET _CategoryNo = (SELECT CategoryNo FROM Mail_MailTemplateCategories WHERE SortNo = _SortNo - 1)
			
			UPDATE Mail_MailTemplateCategories SET SortNo = _SortNo WHERE CategoryNo = _CategoryNo			;
			UPDATE Mail_MailTemplateCategories SET SortNo = _SortNo - 1 WHERE CategoryNo = mail_updatemailtemplatecategory_sortno.categoryno
		
		END

	END
	
	ELSE BEGIN
	
		IF (_SortNo != TopSortNo) BEGIN
		
			SET _CategoryNo = (SELECT CategoryNo FROM Mail_MailTemplateCategories WHERE SortNo = _SortNo + 1)
			
			UPDATE Mail_MailTemplateCategories SET SortNo = _SortNo WHERE CategoryNo = _CategoryNo			;
			UPDATE Mail_MailTemplateCategories SET SortNo = _SortNo + 1 WHERE CategoryNo = mail_updatemailtemplatecategory_sortno.categoryno
		
		END
		
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
