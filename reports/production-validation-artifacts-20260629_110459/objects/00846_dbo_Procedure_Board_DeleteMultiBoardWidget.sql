-- ─── PROCEDURE→FUNCTION: board_deletemultiboardwidget ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.board_deletemultiboardwidget(integer, integer);
CREATE OR REPLACE FUNCTION public.board_deletemultiboardwidget(
    IN userno integer,
    IN boardno integer
) RETURNS void
AS $function$
BEGIN


	UPDATE Board_MultiBoardWidget SET IsDelete= TRUE,ModUserNo=board_deletemultiboardwidget.userno,ModDate=NOW() WHERE BoardNo = board_deletemultiboardwidget.boardno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
