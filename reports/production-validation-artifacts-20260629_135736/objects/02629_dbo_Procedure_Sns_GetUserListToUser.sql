-- ─── PROCEDURE→FUNCTION: sns_getuserlisttouser ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.sns_getuserlisttouser(integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.sns_getuserlisttouser(
    IN groupno integer,
    IN userno integer,
    IN currentpageindex integer,
    IN viewcount integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT UserNo,GroupName,Name,PosName,SortNo,IsMaker,TotalCnt FROM (SELECT ROW_NUMBER() OVER (ORDER BY (SELECT SortNo FROM Organization_Positions WHERE PositionNo IN (SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo=U.UserNo))) AS ROW_NUM,U.UserNo,'' AS GroupName,U.Name
	,(SELECT Name FROM Organization_Positions WHERE PositionNo IN (SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo=U.UserNo)) AS PosName
	,(SELECT SortNo FROM Organization_Positions WHERE PositionNo IN (SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo=U.UserNo)) AS SortNo
	,(CASE WHEN (SELECT MakeUserNo FROM SnsGroups WHERE GroupNo=sns_getuserlisttouser.groupno) = U.UserNo THEN '0' ELSE '1' END) AS IsMaker
	,(SELECT COUNT(*) FROM Organization_Users UU WHERE UU.UserNo IN (SELECT VALUE FROM public."UF_TEXT_SPLIT"(UserNos,';'))) AS TotalCnt
	FROM Organization_Users U
	WHERE U.UserNo IN (SELECT VALUE FROM public."UF_TEXT_SPLIT"(UserNos,';'))
	AND U.Enabled = TRUE
	) T
	WHERE T.ROW_NUM BETWEEN 
	((CurrentPageIndex - 1) * ViewCount) + 1 AND CurrentPageIndex * ViewCount
	ORDER BY SortNo,Name ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
