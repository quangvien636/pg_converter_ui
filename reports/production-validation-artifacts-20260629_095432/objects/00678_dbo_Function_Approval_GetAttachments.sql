-- ─── FUNCTION: approval_getattachments ───────────────────────────────
DROP FUNCTION IF EXISTS public.approval_getattachments(bigint);
CREATE OR REPLACE FUNCTION public.approval_getattachments(
    documentno bigint
) RETURNS TABLE(
    attachno text,
    documentno text,
    filename text,
    filelength text,
    description text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT AttachNo, DocumentNo, FileName, FileLength, Description
	FROM Approval_Attachments
	WHERE DocumentNo = approval_getattachments.documentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
