-- ─── FUNCTION: board_insertnewboardwidget ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_insertnewboardwidget(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.board_insertnewboardwidget(
    userno integer DEFAULT 70,
    boardno integer DEFAULT 1080,
    type integer DEFAULT 2
) RETURNS void
AS $function$
BEGIN

	IF((SELECT COUNT(*) FROM  Board_NewBoardWidget WHERE BoardNo=board_insertnewboardwidget.boardno AND IsDelete= FALSE AND Type=board_insertnewboardwidget.type)=0)
	BEGIN;
	INSERT INTO public."Board_NewBoardWidget" (RegUserNo,RegDate, ModUserNo,ModDate,BoardNo,Type,Sort,IsDelete) VALUES(UserNo,NOW(),UserNo,NOW(),BoardNo,Type,(SELECT (COALESCE(MAX(Sort),0)+1) FROM Board_NewBoardWidget WHERE  IsDelete= FALSE),'FALSE' )
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
