-- ─── PROCEDURE→FUNCTION: board_deletereply ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.board_deletereply(bigint);
CREATE OR REPLACE FUNCTION public.board_deletereply(
    IN replyno bigint
) RETURNS void
AS $function$
BEGIN



	
	SELECT ContentNo INTO contentno FROM Board_Replies
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
