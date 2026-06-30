-- ─── FUNCTION: note_deletesharesfalse ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_deletesharesfalse(uuid);
CREATE OR REPLACE FUNCTION public.note_deletesharesfalse(
    shareno uuid
) RETURNS void
AS $function$
BEGIN

	
	DELETE FROM Note_Share
	WHERE ShareType = 2 AND ShareNo = note_deletesharesfalse.shareno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
