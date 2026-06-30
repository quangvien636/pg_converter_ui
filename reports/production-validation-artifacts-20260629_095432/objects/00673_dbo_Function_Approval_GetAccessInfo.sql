-- ─── FUNCTION: approval_getaccessinfo ───────────────────────────────
DROP FUNCTION IF EXISTS public.approval_getaccessinfo();
CREATE OR REPLACE FUNCTION public.approval_getaccessinfo(
) RETURNS TABLE(
    userno text,
    regdate text,
    formno text,
    documentno text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT UserNo, RegDate, FormNo, DocumentNo
	FROM ApprovalAccessKeys
	WHERE AccessKey = AccessKey
	
	DELETE FROM ApprovalAccessKeys WHERE AccessKey = AccessKey;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
