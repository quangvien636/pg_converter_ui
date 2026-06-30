-- ─── FUNCTION: sns_getinvitegroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.sns_getinvitegroup(integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.sns_getinvitegroup(
    mode integer,
    gettabtype integer,
    currentpageindex integer,
    viewcount integer
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.


    -- INSERT INTO statements for procedure here
    IF Mode = 0 
	BEGIN
		RETURN QUERY
		SELECT I.GroupNo, I.GroupUserNo, G.GroupName, I.RegDate, U.Name AS UserName, U.UserNo
		,(SELECT COUNT(*) FROM SnsGroupUsers WHERE UserNo=UserNo AND IsJoin = FALSE) AS TotalCnt
		,(SELECT COUNT(*) FROM SnsGroupUsers WHERE UserNo=UserNo AND IsJoin = FALSE AND RegDate>=CONVERT(CHAR(10), NOW(), 23)) AS TodayCnt
		,(SELECT COUNT(*) FROM SnsGroupUsers WHERE UserNo=UserNo AND IsJoin = FALSE AND RegDate<CONVERT(CHAR(10), NOW(), 23)) AS LatedayCnt
		FROM SnsGroupUsers AS I
		INNER JOIN SnsGroups AS G ON G.GroupNo = I.GroupNo
		INNER JOIN Organization_Users AS U ON G.MakeUserNo=U.UserNo
		WHERE I.IsJoin = FALSE AND I.UserNo=UserNo
		ORDER BY I.RegDate DESC
	END
	ELSE IF Mode = 1 AND GetTabType > 0 AND CurrentPageIndex > 0 AND ViewCount > 0
	BEGIN
		IF GetTabType = 1
		BEGIN
			RETURN QUERY
			SELECT GroupNo, GroupUserNo, GroupName, RegDate, UserName, UserNo, TotalCnt, TodayCnt, LatedayCnt FROM
			(SELECT ROW_NUMBER() OVER (ORDER BY I.RegDate DESC) AS RowNum, I.GroupNo, I.GroupUserNo, G.GroupName, I.RegDate, U.Name AS UserName, U.UserNo
			,(SELECT COUNT(*) FROM SnsGroupUsers WHERE UserNo=UserNo AND IsJoin = FALSE) AS TotalCnt
			,(SELECT COUNT(*) FROM SnsGroupUsers WHERE UserNo=UserNo AND IsJoin = FALSE AND RegDate>=CONVERT(CHAR(10), NOW(), 23)) AS TodayCnt
			,(SELECT COUNT(*) FROM SnsGroupUsers WHERE UserNo=UserNo AND IsJoin = FALSE AND RegDate<CONVERT(CHAR(10), NOW(), 23)) AS LatedayCnt
			FROM SnsGroupUsers AS I
			INNER JOIN SnsGroups AS G ON G.GroupNo = I.GroupNo
			INNER JOIN Organization_Users AS U ON G.MakeUserNo=U.UserNo
			WHERE I.IsJoin = FALSE AND I.UserNo=UserNo
			) T
			WHERE T.RowNum BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1 AND CurrentPageIndex * ViewCount
			ORDER BY RegDate DESC
		END
		ELSE IF GetTabType = 2
		BEGIN
			RETURN QUERY
			SELECT GroupNo, GroupUserNo, GroupName, RegDate, UserName, UserNo, TotalCnt, TodayCnt, LatedayCnt FROM
			(SELECT ROW_NUMBER() OVER (ORDER BY I.RegDate DESC) AS RowNum, I.GroupNo, I.GroupUserNo, G.GroupName, I.RegDate, U.Name AS UserName, U.UserNo
			,(SELECT COUNT(*) FROM SnsGroupUsers WHERE UserNo=UserNo AND IsJoin = FALSE) AS TotalCnt
			,(SELECT COUNT(*) FROM SnsGroupUsers WHERE UserNo=UserNo AND IsJoin = FALSE AND RegDate>=CONVERT(CHAR(10), NOW(), 23)) AS TodayCnt
			,(SELECT COUNT(*) FROM SnsGroupUsers WHERE UserNo=UserNo AND IsJoin = FALSE AND RegDate<CONVERT(CHAR(10), NOW(), 23)) AS LatedayCnt
			FROM SnsGroupUsers AS I
			INNER JOIN SnsGroups AS G ON G.GroupNo = I.GroupNo
			INNER JOIN Organization_Users AS U ON G.MakeUserNo=U.UserNo
			WHERE I.IsJoin = FALSE AND I.UserNo=UserNo
			AND I.RegDate >= CONVERT(CHAR(10), NOW(), 23)
			) T
			WHERE T.RowNum BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1 AND CurrentPageIndex * ViewCount
			ORDER BY RegDate DESC
		END
		ELSE IF GetTabType = 3
		BEGIN
			RETURN QUERY
			SELECT GroupNo, GroupUserNo, GroupName, RegDate, UserName, UserNo, TotalCnt, TodayCnt, LatedayCnt FROM
			(SELECT ROW_NUMBER() OVER (ORDER BY I.RegDate DESC) AS RowNum, I.GroupNo, I.GroupUserNo, G.GroupName, I.RegDate, U.Name AS UserName, U.UserNo
			,(SELECT COUNT(*) FROM SnsGroupUsers WHERE UserNo=UserNo AND IsJoin = FALSE) AS TotalCnt
			,(SELECT COUNT(*) FROM SnsGroupUsers WHERE UserNo=UserNo AND IsJoin = FALSE AND RegDate>=CONVERT(CHAR(10), NOW(), 23)) AS TodayCnt
			,(SELECT COUNT(*) FROM SnsGroupUsers WHERE UserNo=UserNo AND IsJoin = FALSE AND RegDate<CONVERT(CHAR(10), NOW(), 23)) AS LatedayCnt
			FROM SnsGroupUsers AS I
			INNER JOIN SnsGroups AS G ON G.GroupNo = I.GroupNo
			INNER JOIN Organization_Users AS U ON G.MakeUserNo=U.UserNo
			WHERE I.IsJoin = FALSE AND I.UserNo=UserNo
			AND I.RegDate < CONVERT(CHAR(10), NOW(), 23)
			) T
			WHERE T.RowNum BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1 AND CurrentPageIndex * ViewCount
			ORDER BY RegDate DESC
		END
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
