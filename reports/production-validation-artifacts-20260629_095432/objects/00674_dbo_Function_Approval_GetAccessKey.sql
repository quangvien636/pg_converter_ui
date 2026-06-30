-- ─── FUNCTION: approval_getaccesskey ───────────────────────────────
DROP FUNCTION IF EXISTS public.approval_getaccesskey();
CREATE OR REPLACE FUNCTION public.approval_getaccesskey(
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
