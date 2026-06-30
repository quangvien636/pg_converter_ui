-- ─── FUNCTION: approval_deleteattachment ───────────────────────────────
DROP FUNCTION IF EXISTS public.approval_deleteattachment(bigint);
CREATE OR REPLACE FUNCTION public.approval_deleteattachment(
    attachno bigint
) RETURNS void
AS $function$
BEGIN


	DELETE FROM Approval_Attachments WHERE AttachNo = approval_deleteattachment.attachno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
