-- ─── FUNCTION: board_deletemultiboardwidget ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_deletemultiboardwidget(integer, integer);
CREATE OR REPLACE FUNCTION public.board_deletemultiboardwidget(
    userno integer,
    boardno integer
) RETURNS void
AS $function$
BEGIN


	UPDATE Board_MultiBoardWidget SET IsDelete= TRUE,ModUserNo=board_deletemultiboardwidget.userno,ModDate=NOW() WHERE BoardNo = board_deletemultiboardwidget.boardno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
