-- ─── PROCEDURE→FUNCTION: note_attachmentupdatefilename ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.note_attachmentupdatefilename(uuid);
CREATE OR REPLACE FUNCTION public.note_attachmentupdatefilename(
    IN attachmentno uuid
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
