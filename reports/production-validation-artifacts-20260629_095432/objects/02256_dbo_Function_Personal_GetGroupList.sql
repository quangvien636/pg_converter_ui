-- ─── FUNCTION: personal_getgrouplist ───────────────────────────────
DROP FUNCTION IF EXISTS public.personal_getgrouplist(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.personal_getgrouplist(
    userno integer,
    currpage integer,
    pagesize integer
) RETURNS TABLE(
    departno text
)
AS $function$
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
