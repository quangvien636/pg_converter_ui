-- ─── FUNCTION: board_getboard ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_getboard(integer);
CREATE OR REPLACE FUNCTION public.board_getboard(
    boardno integer
) RETURNS TABLE(
    moduserno text,
    moddate text,
    name text,
    description text,
    folderno text,
    displaytypeno text,
    sortno text,
    isreply text,
    ishead text,
    isnotice text,
    isrecommend text,
    recommendeddisplaycount text,
    viewmode text,
    enabled text,
    spectype text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT ModUserNo, ModDate, Name, Description, FolderNo, DisplayTypeNo,
		SortNo, IsReply, IsHead, IsNotice, IsRecommend, RecommendedDisplayCount,ViewMode, Enabled,SpecType
	FROM Board_Boards
	WHERE BoardNo = board_getboard.boardno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
