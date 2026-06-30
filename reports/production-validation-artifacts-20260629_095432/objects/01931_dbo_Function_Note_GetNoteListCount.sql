-- ─── FUNCTION: note_getnotelistcount ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_getnotelistcount(character varying, boolean);
CREATE OR REPLACE FUNCTION public.note_getnotelistcount(
    boxtype character varying,
    isread boolean DEFAULT TRUE
) RETURNS TABLE(
    cnt text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT 
		COUNT(NoteNo) AS CNT
	FROM NoteList N
	INNER JOIN NoteBox B ON N.UserNo = B.UserNo AND N.NoteBoxNo = B.NoteBoxNo
	WHERE N.UserNo = UserNo
	AND B.BoxType = note_getnotelistcount.boxtype
	AND (N.IsRead = note_getnotelistcount.isread OR 1=note_getnotelistcount.isread);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
