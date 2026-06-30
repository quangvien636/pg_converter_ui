-- ─── FUNCTION: personal_getgrouplistcount ───────────────────────────────
DROP FUNCTION IF EXISTS public.personal_getgrouplistcount(integer);
CREATE OR REPLACE FUNCTION public.personal_getgrouplistcount(
    userno integer
) RETURNS TABLE(
    departno text
)
AS $function$
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
