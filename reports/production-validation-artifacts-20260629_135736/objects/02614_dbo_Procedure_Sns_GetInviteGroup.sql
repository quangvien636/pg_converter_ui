-- ─── PROCEDURE→FUNCTION: sns_getinvitegroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.sns_getinvitegroup(integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.sns_getinvitegroup(
    IN mode integer,
    IN gettabtype integer,
    IN currentpageindex integer,
    IN viewcount integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

    -- INSERT INTO statements for procedure here
    IF Mode = 0 THEN
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
	END IF;
	ELSIF Mode = 1 AND GetTabType > 0 AND CurrentPageIndex > 0 AND ViewCount > 0 THEN
		IF GetTabType = 1 THEN
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
		END IF;
		ELSIF GetTabType = 2 THEN
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
		END IF;
		ELSIF GetTabType = 3 THEN
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
		END IF;
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
