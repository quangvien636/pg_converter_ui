-- ─── FUNCTION: board_deletenewboardwidget ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_deletenewboardwidget(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.board_deletenewboardwidget(
    userno integer,
    boardno integer,
    type integer
) RETURNS void
AS $function$
BEGIN


	UPDATE Board_NewBoardWidget SET IsDelete= TRUE,ModUserNo=board_deletenewboardwidget.userno,ModDate=NOW() WHERE BoardNo = board_deletenewboardwidget.boardno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
