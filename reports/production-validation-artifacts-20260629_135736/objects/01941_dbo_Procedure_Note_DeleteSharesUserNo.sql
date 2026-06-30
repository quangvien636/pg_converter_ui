-- ─── PROCEDURE→FUNCTION: note_deletesharesuserno ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.note_deletesharesuserno(uuid, integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.note_deletesharesuserno(
    IN listno uuid,
    IN companyno integer,
    IN userno integer,
    IN sharecompanyno integer,
    IN shareuserno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	


	SELECT COUNT(ListNo) INTO owernote FROM Note_List WHERE UserNo = note_deletesharesuserno.userno AND ListNo = note_deletesharesuserno.listno
	IF OwerNote > 0 THEN;
		DELETE FROM Note_Share
		WHERE ShareType = 2
			AND ListNo=note_deletesharesuserno.listno
			AND UserShare=note_deletesharesuserno.shareuserno 
			AND (ShareCompanyNo = note_deletesharesuserno.sharecompanyno OR ShareCompanyNo IS NULL)
	END IF;
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
