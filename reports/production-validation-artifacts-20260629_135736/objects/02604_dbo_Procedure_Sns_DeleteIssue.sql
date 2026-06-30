-- ─── PROCEDURE→FUNCTION: sns_deleteissue ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.sns_deleteissue(integer, integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.sns_deleteissue(
    IN userno integer,
    IN messageno integer,
    IN groupno integer,
    IN issuetype integer,
    IN actiontype integer
) RETURNS void
AS $function$
BEGIN

	
	-- 소식타입(0:게시글,1:댓글,2:초대)
    -- 행동타입(0:좋아요,1:싫어요,2:댓글,3:공유,4:초대,5:거부);
	DELETE FROM SnsIssues 
	WHERE ParentNo=sns_deleteissue.messageno AND IssueType=sns_deleteissue.issuetype
	AND ActionType=sns_deleteissue.actiontype AND Send_UserNo=sns_deleteissue.userno
	AND GroupNo=sns_deleteissue.groupno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
