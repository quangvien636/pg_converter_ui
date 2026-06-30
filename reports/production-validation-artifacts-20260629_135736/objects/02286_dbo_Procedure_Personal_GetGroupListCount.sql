-- ─── PROCEDURE→FUNCTION: personal_getgrouplistcount ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.personal_getgrouplistcount(integer);
CREATE OR REPLACE FUNCTION public.personal_getgrouplistcount(
    IN userno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT COUNT(*) AS CNT
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
		CASE WHEN RegUserNo = personal_getgrouplistcount.userno THEN '1' ELSE '0' END AS ModYN 
	FROM PersonalGroup G
	WHERE RegUserNo = personal_getgrouplistcount.userno OR DepartNo IN (SELECT DepartNo FROM Organization_BelongToDepartment WHERE UserNo = personal_getgrouplistcount.userno)
	) A;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
