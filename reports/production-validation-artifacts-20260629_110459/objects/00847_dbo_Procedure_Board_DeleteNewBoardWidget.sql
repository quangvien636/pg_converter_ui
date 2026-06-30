-- ─── PROCEDURE→FUNCTION: board_deletenewboardwidget ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.board_deletenewboardwidget(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.board_deletenewboardwidget(
    IN userno integer,
    IN boardno integer,
    IN type integer
) RETURNS void
AS $function$
BEGIN


	UPDATE Board_NewBoardWidget SET IsDelete= TRUE,ModUserNo=board_deletenewboardwidget.userno,ModDate=NOW() WHERE BoardNo = board_deletenewboardwidget.boardno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
