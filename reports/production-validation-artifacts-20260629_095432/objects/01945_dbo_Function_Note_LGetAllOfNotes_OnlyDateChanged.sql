-- ─── FUNCTION: note_lgetallofnotes_onlydatechanged ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_lgetallofnotes_onlydatechanged(integer);
CREATE OR REPLACE FUNCTION public.note_lgetallofnotes_onlydatechanged(
    userno integer
) RETURNS TABLE(
    noteno text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT NoteNo, DateChanged
	FROM Note_LNotes
	WHERE UserNo = note_lgetallofnotes_onlydatechanged.userno OR NoteNo IN (SELECT NoteNo FROM Note_LSharers WHERE UserShare = note_lgetallofnotes_onlydatechanged.userno);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
