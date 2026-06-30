-- ─── PROCEDURE→FUNCTION: sns_deletereply ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.sns_deletereply(integer);
CREATE OR REPLACE FUNCTION public.sns_deletereply(
    IN replyno integer
) RETURNS void
AS $function$
BEGIN

	DELETE FROM SnsReplys WHERE ReplyNo=sns_deletereply.replyno;
	DELETE FROM SnsReplyChk WHERE ReplyNo=sns_deletereply.replyno
	
	--관계된 좋아요/싫어요
	--소식타입(0:게시글,1:댓글,2:초대)
	--행동타입(0:좋아요,1:싫어요,2:댓글,3:공유,4:초대,5:거부);
	DELETE FROM SnsIssues WHERE ParentNo=sns_deletereply.replyno 
	AND IssueType = TRUE AND ActionType IN (0,1);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
