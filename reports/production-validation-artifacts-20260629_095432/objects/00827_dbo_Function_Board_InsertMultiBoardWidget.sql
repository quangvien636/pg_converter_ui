-- ─── FUNCTION: board_insertmultiboardwidget ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_insertmultiboardwidget(integer, integer);
CREATE OR REPLACE FUNCTION public.board_insertmultiboardwidget(
    userno integer DEFAULT 70,
    boardno integer DEFAULT 1080
) RETURNS void
AS $function$
BEGIN

	IF((SELECT COUNT(*) FROM  Board_MultiBoardWidget WHERE BoardNo=board_insertmultiboardwidget.boardno AND IsDelete= FALSE )=0)
	BEGIN;
	INSERT INTO public."Board_MultiBoardWidget" (RegUserNo,RegDate, ModUserNo,ModDate,BoardNo,Sort,IsDelete) VALUES(UserNo,NOW(),UserNo,NOW(),BoardNo,(SELECT (COALESCE(MAX(Sort),0)+1) FROM Board_MultiBoardWidget WHERE  IsDelete= FALSE),'FALSE' )
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
