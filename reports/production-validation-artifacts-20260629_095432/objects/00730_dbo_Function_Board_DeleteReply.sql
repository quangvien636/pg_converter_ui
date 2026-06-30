-- ─── FUNCTION: board_deletereply ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_deletereply(bigint);
CREATE OR REPLACE FUNCTION public.board_deletereply(
    replyno bigint
) RETURNS void
AS $function$
BEGIN



	
	SELECT ContentNo = ContentNo, OrderNo = OrderNo
	FROM Board_Replies
	WHERE ReplyNo = board_deletereply.replyno

	UPDATE Board_Replies SET OrderNo = OrderNo - 1
	WHERE ContentNo = ContentNo AND OrderNo > OrderNo

	DELETE FROM Board_Replies WHERE ReplyNo = board_deletereply.replyno
	
	UPDATE Board_Contents SET ReplyCount = ReplyCount -1
	WHERE ContentNo = ContentNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
