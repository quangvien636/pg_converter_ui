-- ─── PROCEDURE→FUNCTION: note_lupdaterepresentative ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.note_lupdaterepresentative(uuid, uuid);
CREATE OR REPLACE FUNCTION public.note_lupdaterepresentative(
    IN noteno uuid,
    IN attachmentno uuid
) RETURNS void
AS $function$
BEGIN


	UPDATE Note_Attachment SET IsAvatar = FALSE
	WHERE ListNo = note_lupdaterepresentative.noteno

	UPDATE Note_Attachment SET IsAvatar = TRUE
	WHERE AttachmentNo = note_lupdaterepresentative.attachmentno

	UPDATE Note_List SET DayEdit = GETUTCDATE()
	WHERE ListNo = note_lupdaterepresentative.noteno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
