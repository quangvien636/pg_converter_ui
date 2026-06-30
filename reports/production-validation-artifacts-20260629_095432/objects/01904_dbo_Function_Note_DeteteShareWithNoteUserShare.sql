-- ─── FUNCTION: note_detetesharewithnoteusershare ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_detetesharewithnoteusershare(uuid, integer);
CREATE OR REPLACE FUNCTION public.note_detetesharewithnoteusershare(
    listno uuid,
    userno integer
) RETURNS void
AS $function$
BEGIN

	DELETE FROM Note_Share
	WHERE ListNo=note_detetesharewithnoteusershare.listno AND UserShare=note_detetesharewithnoteusershare.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
