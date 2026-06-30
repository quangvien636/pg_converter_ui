-- ─── PROCEDURE→FUNCTION: board_insertcommentsetting ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.board_insertcommentsetting(integer, integer);
CREATE OR REPLACE FUNCTION public.board_insertcommentsetting(
    IN userno integer DEFAULT 70,
    IN boardno integer DEFAULT 1080
) RETURNS void
AS $function$
BEGIN

	IF (SELECT COUNT(*) FROM  Board_CommentSetting WHERE BoardNo=board_insertcommentsetting.boardno AND IsDelete= FALSE)=0 THEN
	INSERT INTO public."Board_CommentSetting" (RegUserNo,RegDate, ModUserNo,ModDate,BoardNo,IsDelete) VALUES(UserNo,NOW(),UserNo,NOW(),BoardNo,'FALSE' );;
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.