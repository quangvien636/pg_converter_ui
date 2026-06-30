-- ─── FUNCTION: board_deletefilebycontent ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_deletefilebycontent(bigint);
CREATE OR REPLACE FUNCTION public.board_deletefilebycontent(
    contentno bigint
) RETURNS void
AS $function$
BEGIN


	DELETE FROM Board_Files WHERE ContentNo = board_deletefilebycontent.contentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
