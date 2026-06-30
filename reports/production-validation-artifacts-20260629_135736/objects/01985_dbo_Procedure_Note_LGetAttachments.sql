-- ─── PROCEDURE→FUNCTION: note_lgetattachments ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.note_lgetattachments(uuid);
CREATE OR REPLACE FUNCTION public.note_lgetattachments(
    IN noteno uuid
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT AttachmentNo, UserNo, FileUrl, ListNo, TypeFile, DayCreate, DayEdit, fileURI, RealPath,
		IsAvatar, AttachTimeZone, FileSize, FileName
	FROM Note_Attachment
	WHERE ListNo = note_lgetattachments.noteno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
