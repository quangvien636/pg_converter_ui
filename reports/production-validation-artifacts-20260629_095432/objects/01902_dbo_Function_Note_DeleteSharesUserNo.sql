-- ─── FUNCTION: note_deletesharesuserno ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_deletesharesuserno(uuid, integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.note_deletesharesuserno(
    listno uuid,
    companyno integer,
    userno integer,
    sharecompanyno integer,
    shareuserno integer
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN

	


	SELECT OwerNote = COUNT(ListNo) FROM Note_List WHERE UserNo = note_deletesharesuserno.userno AND ListNo = note_deletesharesuserno.listno
	IF OwerNote > 0 BEGIN;
		DELETE FROM Note_Share
		WHERE ShareType = 2
			AND ListNo=note_deletesharesuserno.listno
			AND UserShare=note_deletesharesuserno.shareuserno 
			AND (ShareCompanyNo = note_deletesharesuserno.sharecompanyno OR ShareCompanyNo IS NULL)
	END
	ELSE BEGIN;
		DELETE FROM Note_Share
		WHERE ShareType = 2
			AND ListNo=note_deletesharesuserno.listno
			AND UserShare=note_deletesharesuserno.shareuserno 
			AND (ShareCompanyNo=note_deletesharesuserno.sharecompanyno OR ShareCompanyNo IS NULL)
			AND ((UserNo=note_deletesharesuserno.userno AND (CompanyNo=note_deletesharesuserno.companyno OR CompanyNo IS NULL)) 
				OR (UserShare=note_deletesharesuserno.userno AND (ShareCompanyNo=note_deletesharesuserno.companyno OR ShareCompanyNo IS NULL)))
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
