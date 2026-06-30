-- ─── PROCEDURE→FUNCTION: board_updateboard ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.board_updateboard(integer, integer, timestamp without time zone, character varying, character varying, integer, integer, integer, boolean, boolean, boolean, boolean, integer, boolean);
CREATE OR REPLACE FUNCTION public.board_updateboard(
    IN boardno integer,
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN name character varying,
    IN description character varying,
    IN folderno integer,
    IN displaytypeno integer,
    IN sortno integer,
    IN isreply boolean,
    IN ishead boolean,
    IN isnotice boolean,
    IN isrecommend boolean,
    IN recommendeddisplaycount integer,
    IN enabled boolean
) RETURNS void
AS $function$
BEGIN

	UPDATE public."Board_Boards"
   SET ModUserNo = board_updateboard.moduserno
      ,ModDate = board_updateboard.moddate
      ,Name = board_updateboard.name
      ,Description = board_updateboard.description
      ,FolderNo = board_updateboard.folderno
      ,DisplayTypeNo = board_updateboard.displaytypeno
      ,SortNo = board_updateboard.sortno
      ,IsReply = board_updateboard.isreply
      ,IsHead = board_updateboard.ishead
      ,IsNotice = board_updateboard.isnotice
      ,IsRecommend = board_updateboard.isrecommend
      ,RecommendedDisplayCount = board_updateboard.recommendeddisplaycount
      ,Enabled = board_updateboard.enabled
 WHERE Board_Boards.BoardNo=board_updateboard.boardno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
