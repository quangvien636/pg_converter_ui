-- ─── PROCEDURE→FUNCTION: sns_getgrouptopissue ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
-- TODO: DATEADD was not fully converted; use interval arithmetic
DROP FUNCTION IF EXISTS public.sns_getgrouptopissue(integer);
CREATE OR REPLACE FUNCTION public.sns_getgrouptopissue(
    IN userno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT UserNo, GroupNo, MessageNo, Message, RegDate, CNT, Type FROM
	(
	(SELECT /* TOP 1 */ M.UserNo,M.GroupNo,M.MessageNo,M.Message,I.RegDate,
	(SELECT COUNT(*) FROM SnsIssues WHERE IssueType = FALSE AND ActionType=0 AND ParentNo=M.MessageNo) AS CNT
	,0 AS Type
	FROM SnsMessages M
	INNER JOIN SnsIssues I ON I.ParentNo = M.MessageNo
	WHERE M.GroupNo IN (SELECT GroupNo FROM SnsGroupUsers WHERE UserNo=sns_getgrouptopissue.userno AND IsJoin = TRUE)
	AND I.IssueType = FALSE AND I.ActionType=0
	AND MONTH(I.RegDate) = MONTH(NOW())
	AND DAY(I.RegDate) BETWEEN DAY(DateAdd(Day,-(DatePart(dw,NOW())-2),NOW())) 
	AND DAY(DateAdd(Day,(8-DatePart(dw,NOW())),NOW()))
	ORDER BY CNT DESC, M.RegDate DESC)
	UNION ALL
	(SELECT /* TOP 1 */ M.UserNo,M.GroupNo,M.MessageNo,M.Message,I.RegDate,
	(SELECT COUNT(*) FROM SnsIssues WHERE IssueType = FALSE AND ActionType=1 AND ParentNo=M.MessageNo) AS CNT
	,1 AS Type
	FROM SnsMessages M
	INNER JOIN SnsIssues I ON I.ParentNo = M.MessageNo
	WHERE M.GroupNo IN (SELECT GroupNo FROM SnsGroupUsers WHERE UserNo=sns_getgrouptopissue.userno AND IsJoin = TRUE)
	AND I.IssueType = FALSE AND I.ActionType=1
	AND MONTH(I.RegDate) = MONTH(NOW())
	AND DAY(I.RegDate) BETWEEN DAY(DateAdd(Day,-(DatePart(dw,NOW())-2),NOW())) 
	AND DAY(DateAdd(Day,(8-DatePart(dw,NOW())),NOW()))
	ORDER BY CNT DESC, M.RegDate DESC)
	UNION ALL
	(SELECT /* TOP 1 */ M.UserNo,M.GroupNo,M.MessageNo,M.Message,I.RegDate,
	(SELECT COUNT(*) FROM SnsIssues WHERE IssueType = FALSE AND ActionType=3 AND ParentNo=M.MessageNo) AS CNT
	,3 AS Type
	FROM SnsMessages M
	INNER JOIN SnsIssues I ON I.ParentNo = M.MessageNo
	WHERE M.GroupNo IN (SELECT GroupNo FROM SnsGroupUsers WHERE UserNo=sns_getgrouptopissue.userno AND IsJoin = TRUE)
	AND I.IssueType = FALSE AND I.ActionType=3
	AND MONTH(I.RegDate) = MONTH(NOW())
	AND DAY(I.RegDate) BETWEEN DAY(DateAdd(Day,-(DatePart(dw,NOW())-2),NOW())) 
	AND DAY(DateAdd(Day,(8-DatePart(dw,NOW())),NOW()))
	ORDER BY CNT DESC, M.RegDate DESC)
	) T;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
