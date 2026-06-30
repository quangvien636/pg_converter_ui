-- ─── FUNCTION: board_updateboard ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_updateboard(integer, integer, timestamp without time zone, character varying, character varying, integer, integer, integer, boolean, boolean, boolean, boolean, integer, boolean);
CREATE OR REPLACE FUNCTION public.board_updateboard(
    boardno integer,
    moduserno integer,
    moddate timestamp without time zone,
    name character varying,
    description character varying,
    folderno integer,
    displaytypeno integer,
    sortno integer,
    isreply boolean,
    ishead boolean,
    isnotice boolean,
    isrecommend boolean,
    recommendeddisplaycount integer,
    enabled boolean
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
