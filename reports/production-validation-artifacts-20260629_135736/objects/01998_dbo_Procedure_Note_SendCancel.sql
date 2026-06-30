-- ─── PROCEDURE→FUNCTION: note_sendcancel ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.note_sendcancel();
CREATE OR REPLACE FUNCTION public.note_sendcancel(
) RETURNS void
AS $function$
BEGIN

	DELETE
	FROM NoteList
	WHERE SendNoteNo = SendNoteNo
	AND IsRead = FALSE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
