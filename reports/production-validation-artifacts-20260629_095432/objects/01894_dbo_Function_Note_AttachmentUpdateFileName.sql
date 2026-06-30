-- ─── FUNCTION: note_attachmentupdatefilename ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_attachmentupdatefilename(uuid);
CREATE OR REPLACE FUNCTION public.note_attachmentupdatefilename(
    attachmentno uuid
) RETURNS void
AS $function$
BEGIN

	UPDATE Note_Attachment
	SET
		FileName = FileName
	WHERE AttachmentNo = note_attachmentupdatefilename.attachmentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
