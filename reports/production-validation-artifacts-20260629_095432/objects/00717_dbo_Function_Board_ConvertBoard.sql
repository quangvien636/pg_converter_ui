-- ─── FUNCTION: board_convertboard ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_convertboard(integer, integer);
CREATE OR REPLACE FUNCTION public.board_convertboard(
    boardno integer,
    viewmode integer
) RETURNS void
AS $function$
BEGIN
UPDATE Board_Boards SET ViewMode = board_convertboard.viewmode WHERE BoardNo= board_convertboard.boardno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
