-- ─── PROCEDURE→FUNCTION: personal_getgrouplist ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.personal_getgrouplist(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.personal_getgrouplist(
    IN userno integer,
    IN currpage integer,
    IN pagesize integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT *
	FROM
	(
	SELECT
		ROW_NUMBER() OVER(ORDER BY GroupNo DESC) AS RowNum,
		GroupNo,
		GroupName,
		(SELECT COUNT(SeqNo) FROM PersonalGroupUser U WHERE U.GroupNo = G.GroupNo) AS UserCount,
		Description,
		ShareType,
		DepartNo,
		COALESCE((SELECT Name FROM Organization_Departments D WHERE D.DepartNo = G.DepartNo),'') AS DepartName,
		CASE WHEN RegUserNo = personal_getgrouplist.userno THEN '1' ELSE '0' END AS ModYN 
	FROM PersonalGroup G
	WHERE RegUserNo = personal_getgrouplist.userno OR DepartNo IN (SELECT DepartNo FROM Organization_BelongToDepartment WHERE UserNo = personal_getgrouplist.userno)
	) A
	WHERE RowNum BETWEEN ((CurrPage-1) * PageSize + 1) AND (CurrPage * PageSize);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
