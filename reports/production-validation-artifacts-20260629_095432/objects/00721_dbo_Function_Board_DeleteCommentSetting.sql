-- ─── FUNCTION: board_deletecommentsetting ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_deletecommentsetting(integer, integer);
CREATE OR REPLACE FUNCTION public.board_deletecommentsetting(
    userno integer,
    boardno integer
) RETURNS void
AS $function$
BEGIN


	UPDATE Board_CommentSetting SET IsDelete= TRUE,ModUserNo=board_deletecommentsetting.userno,ModDate=NOW() WHERE BoardNo = board_deletecommentsetting.boardno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
