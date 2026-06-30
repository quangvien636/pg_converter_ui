-- ─── FUNCTION: note_attachmentupdatedayedit ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_attachmentupdatedayedit(uuid);
CREATE OR REPLACE FUNCTION public.note_attachmentupdatedayedit(
    attachmentno uuid
) RETURNS void
AS $function$
BEGIN

	
	UPDATE Note_Attachment
	SET DayEdit = NOW()
	WHERE AttachmentNo = note_attachmentupdatedayedit.attachmentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
