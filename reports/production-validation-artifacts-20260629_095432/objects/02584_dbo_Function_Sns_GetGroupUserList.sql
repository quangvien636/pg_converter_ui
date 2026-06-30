-- ─── FUNCTION: sns_getgroupuserlist ───────────────────────────────
DROP FUNCTION IF EXISTS public.sns_getgroupuserlist(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.sns_getgroupuserlist(
    mode integer,
    currentpageindex integer,
    viewcount integer
) RETURNS TABLE(
    rownum text,
    groupno text,
    groupname text,
    makeuserno text,
    grouptype text,
    regdate text,
    opentype text,
    enabled text,
    col9 text
)
AS $function$
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	
    -- INSERT INTO statements for procedure here
	IF Mode = 0 
	BEGIN
	
	RETURN QUERY
	SELECT DISTINCT ROW_NUMBER() OVER (ORDER BY A.RegDate ASC) AS RowNum, A.GroupNo, A.GroupName, A.MakeUserNo, 
	A.GroupType, A.RegDate, A.OpenType, A.Enabled,
	(SELECT COUNT(*) FROM SnsMessageChk AS C 
	WHERE C.GroupNo=A.GroupNo AND C.IsCheck = FALSE AND C.UserNo=UserNo ) AS NoReadCnt,
	B.IsBookmark, B.GroupUserNo
	FROM SnsGroups AS A
	INNER JOIN SnsGroupUsers AS B ON B.GroupNo=A.GroupNo AND B.UserNo=UserNo
	INNER JOIN Organization_Users AS U ON B.UserNo=U.UserNo
	WHERE U.UserNo = UserNo AND B.IsJoin = TRUE OR OpenType=0
	ORDER BY A.RegDate ASC
	
	END
	ELSE IF Mode = 1 AND CurrentPageIndex > 0 AND ViewCount > 0
	BEGIN
	
	RETURN QUERY
	SELECT GroupNo, GroupName, MakeUserNo, GroupType, RegDate, OpenType, Enabled, NoReadCnt, IsBookmark, GroupUserNo FROM
	(SELECT DISTINCT ROW_NUMBER() OVER (ORDER BY A.RegDate ASC) AS RowNum, A.GroupNo, A.GroupName, A.MakeUserNo, 
	A.GroupType, A.RegDate, A.OpenType, A.Enabled,
	(SELECT COUNT(*) FROM SnsMessageChk AS C 
	WHERE C.GroupNo=A.GroupNo AND C.IsCheck = FALSE AND C.UserNo=UserNo ) AS NoReadCnt,
	B.IsBookmark, B.GroupUserNo
	FROM SnsGroups AS A
	INNER JOIN SnsGroupUsers AS B ON B.GroupNo=A.GroupNo AND B.UserNo=UserNo
	INNER JOIN Organization_Users AS U ON B.UserNo=U.UserNo
	WHERE U.UserNo = UserNo AND B.IsJoin = TRUE OR OpenType=0)
	T
	WHERE T.RowNum BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1 AND CurrentPageIndex * ViewCount
	ORDER BY RegDate ASC
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
