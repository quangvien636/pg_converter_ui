-- ─── FUNCTION: note_sendcancel ───────────────────────────────
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
