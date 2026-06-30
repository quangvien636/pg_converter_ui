-- ─── FUNCTION: approval_getattachment ───────────────────────────────
DROP FUNCTION IF EXISTS public.approval_getattachment(bigint);
CREATE OR REPLACE FUNCTION public.approval_getattachment(
    attachno bigint
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
	FROM Approval_Attachments WHERE AttachNo = approval_getattachment.attachno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
