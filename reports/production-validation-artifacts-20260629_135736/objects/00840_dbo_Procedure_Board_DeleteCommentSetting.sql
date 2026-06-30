-- ─── PROCEDURE→FUNCTION: board_deletecommentsetting ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.board_deletecommentsetting(integer, integer);
CREATE OR REPLACE FUNCTION public.board_deletecommentsetting(
    IN userno integer,
    IN boardno integer
) RETURNS void
AS $function$
BEGIN


	UPDATE Board_CommentSetting SET IsDelete= TRUE,ModUserNo=board_deletecommentsetting.userno,ModDate=NOW() WHERE BoardNo = board_deletecommentsetting.boardno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
