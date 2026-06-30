-- ─── PROCEDURE→FUNCTION: sns_getreplys ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.sns_getreplys(integer);
CREATE OR REPLACE FUNCTION public.sns_getreplys(
    IN messageno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT R.ReplyNo, R.MessageNo, R.UserNo, R.Message, R.GroupNo, R.RegDate,
	G.GroupName,U.Name,
	(SELECT COUNT(*) FROM SnsIssues WHERE ParentNo=R.MessageNo AND IssueType = TRUE AND ActionType=0) AS LikeCnt,
	(SELECT COUNT(*) FROM SnsIssues WHERE ParentNo=R.MessageNo AND IssueType = TRUE AND ActionType=1) AS HateCnt
	FROM SnsReplys R
	INNER JOIN SnsGroups G ON G.GroupNo=R.GroupNo
	INNER JOIN Organization_Users U ON U.UserNo = R.UserNo
	WHERE R.MessageNo = sns_getreplys.messageno
	ORDER BY R.RegDate ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
