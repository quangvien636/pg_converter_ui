-- ─── PROCEDURE→FUNCTION: board_insertnewboardwidget ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.board_insertnewboardwidget(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.board_insertnewboardwidget(
    IN userno integer DEFAULT 70,
    IN boardno integer DEFAULT 1080,
    IN type integer DEFAULT 2
) RETURNS void
AS $function$
BEGIN

	IF (SELECT COUNT(*) FROM  Board_NewBoardWidget WHERE BoardNo=board_insertnewboardwidget.boardno AND IsDelete= FALSE AND Type=board_insertnewboardwidget.type)=0 THEN
	INSERT INTO public."Board_NewBoardWidget" (RegUserNo,RegDate, ModUserNo,ModDate,BoardNo,Type,Sort,IsDelete) VALUES(UserNo,NOW(),UserNo,NOW(),BoardNo,Type,(SELECT (COALESCE(MAX(Sort),0)+1) FROM Board_NewBoardWidget WHERE  IsDelete= FALSE),'FALSE' );;
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.