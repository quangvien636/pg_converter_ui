-- ─── PROCEDURE→FUNCTION: sns_getmytalkmsgcount ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.sns_getmytalkmsgcount(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.sns_getmytalkmsgcount(
    IN mytalkuserno integer,
    IN userno integer,
    IN gettabtype integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	
	RETURN QUERY
	SELECT COUNT(MessageNo) AS CNT FROM 					

			((SELECT M.MessageNo, M.UserNo, M.GroupNo, M.RegDate, M.Message,
			M.IsAttach, M.IsPicture, M.IsShare, M.ShareContentNo, G.GroupName, M.IsDelete
			FROM SnsMessages AS M
			INNER JOIN SnsGroups AS G ON G.GroupNo=M.GroupNo
			WHERE M.IsDelete = FALSE AND M.UserNo = sns_getmytalkmsgcount.mytalkuserno
			AND M.GroupNo != (SELECT GroupNo FROM SnsGroups WHERE GroupType=104 AND MakeUserNo=sns_getmytalkmsgcount.mytalkuserno)
			)

			UNION ALL

			(SELECT M.MessageNo, M.UserNo, M.GroupNo, M.RegDate, M.Message,
			M.IsAttach, M.IsPicture, M.IsShare, M.ShareContentNo, G.GroupName, M.IsDelete
			FROM SnsMessages AS M
			INNER JOIN SnsGroups AS G ON G.GroupNo=M.GroupNo
			WHERE M.IsDelete = FALSE 
			AND M.GroupNo IN (SELECT GroupNo FROM SnsGroups WHERE GroupType=104 AND MakeUserNo=sns_getmytalkmsgcount.mytalkuserno)
			))

			A WHERE 
			GroupNo IN 
			(
			SELECT GroupNo FROM SnsGroupUsers WHERE UserNo = sns_getmytalkmsgcount.userno
			UNION ALL
			SELECT GroupNo FROM SnsGroups WHERE GroupType=104 AND MakeUserNo=sns_getmytalkmsgcount.mytalkuserno
			)
			AND A.IsAttach IN ((CASE WHEN GetTabType=3 THEN 1 ELSE 0 END),(CASE WHEN GetTabType=1 THEN 1 ELSE 1 END))
			AND A.IsPicture IN ((CASE WHEN GetTabType=2 THEN 1 ELSE 0 END),(CASE WHEN GetTabType=1 THEN 1 ELSE 1 END))
			AND RegDate < NOW();
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
