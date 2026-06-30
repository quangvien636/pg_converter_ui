-- ─── FUNCTION: approval_insertattachment ───────────────────────────────
DROP FUNCTION IF EXISTS public.approval_insertattachment(bigint, character varying, integer);
CREATE OR REPLACE FUNCTION public.approval_insertattachment(
    documentno bigint,
    filename character varying,
    filelength integer
) RETURNS TABLE(
    attachno text
)
AS $function$
DECLARE
    attachno bigint;
BEGIN


	INSERT INTO Approval_Attachments (DocumentNo, FileName, FileLength, Description)
	VALUES(DocumentNo, FileName, FileLength, Description)
	

	SET AttachNo = lastval()
	
	RETURN QUERY
	SELECT AttachNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
