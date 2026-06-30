-- ─── PROCEDURE→FUNCTION: sns_deletemessage ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.sns_deletemessage(integer);
CREATE OR REPLACE FUNCTION public.sns_deletemessage(
    IN messageno integer
) RETURNS void
AS $function$
BEGIN

	
	UPDATE SnsMessages SET IsDelete = TRUE WHERE MessageNo=sns_deletemessage.messageno;
	DELETE FROM SnsMessageChk WHERE MessageNo=sns_deletemessage.messageno
	
	--관계된 댓글들도 삭제시킨다.	;
	DELETE FROM SnsReplys WHERE MessageNo=sns_deletemessage.messageno;
	DELETE FROM SnsReplyChk 
	WHERE ReplyNo IN (SELECT ReplyNo FROM SnsReplys WHERE MessageNo=sns_deletemessage.messageno)
	
	--관계된 첨부파일도 삭제시킨다.FileType(0:사진 1:기타 2:유저프로필);
	DELETE FROM SnsAttachs WHERE MessageNo=sns_deletemessage.messageno AND FileType IN (0,1)
	
	--관계된 좋아요/싫어요
	--소식타입(0:게시글,1:댓글,2:초대)
	--행동타입(0:좋아요,1:싫어요,2:댓글,3:공유,4:초대,5:거부);
	DELETE FROM SnsIssues WHERE ParentNo=sns_deletemessage.messageno AND IssueType = FALSE AND ActionType IN (0,1,2);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
