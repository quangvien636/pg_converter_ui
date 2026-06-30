-- ─── PROCEDURE→FUNCTION: note_attachmentupdatedayedit ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.note_attachmentupdatedayedit(uuid);
CREATE OR REPLACE FUNCTION public.note_attachmentupdatedayedit(
    IN attachmentno uuid
) RETURNS void
AS $function$
BEGIN

	
	UPDATE Note_Attachment
	DayEdit := NOW();
	WHERE AttachmentNo = note_attachmentupdatedayedit.attachmentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
