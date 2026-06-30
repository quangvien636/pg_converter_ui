-- ─── PROCEDURE→FUNCTION: sns_getissuecount ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.sns_getissuecount(integer, integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.sns_getissuecount(
    IN userno integer,
    IN messageno integer,
    IN groupno integer,
    IN issuetype integer,
    IN actiontype integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	
	-- 소식타입(0:게시글,1:댓글,2:초대)
    -- 행동타입(0:좋아요,1:싫어요,2:댓글,3:공유,4:초대,5:거부)
	RETURN QUERY
	SELECT COUNT(*) AS CNT FROM SnsIssues 
	WHERE ParentNo=sns_getissuecount.messageno AND IssueType=sns_getissuecount.issuetype
	AND ActionType=sns_getissuecount.actiontype AND Send_UserNo=sns_getissuecount.userno
	AND GroupNo=sns_getissuecount.groupno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
