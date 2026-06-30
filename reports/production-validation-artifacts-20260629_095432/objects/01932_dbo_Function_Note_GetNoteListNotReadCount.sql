-- ─── FUNCTION: note_getnotelistnotreadcount ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_getnotelistnotreadcount();
CREATE OR REPLACE FUNCTION public.note_getnotelistnotreadcount(
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
	AND N.IsRead = FALSE
	AND B.BoxType = BoxType;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
