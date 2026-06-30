-- ─── FUNCTION: sns_getpeoplelist ───────────────────────────────
DROP FUNCTION IF EXISTS public.sns_getpeoplelist(integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.sns_getpeoplelist(
    userno integer,
    sort integer,
    currentpageindex integer,
    viewcount integer
) RETURNS TABLE(
    groupno text
)
AS $function$
BEGIN



	IF GetTabType > 0 AND CurrentPageIndex > 0 AND ViewCount > 0
	BEGIN
		IF GetTabType = 1
		--회사전체 인원정보
		BEGIN
			IF Sort = 1
			--전체기본 정렬
			BEGIN
				RETURN QUERY
				SELECT UserNo,GroupName,Name,PosName,SortNo FROM 
				(SELECT ROW_NUMBER() OVER (ORDER BY (SELECT SortNo FROM Organization_Positions WHERE PositionNo IN (SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo=U.UserNo)) ASC) AS RowNum,
				U.UserNo,'' AS GroupName,U.Name,
				(SELECT SortNo FROM Organization_Positions WHERE PositionNo IN (SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo=U.UserNo)) AS SortNo,
				(SELECT Name FROM Organization_Positions WHERE PositionNo IN (SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo=U.UserNo)) AS PosName
				,(SELECT COUNT(*) FROM Organization_Users WHERE Enabled = TRUE) AS TotalCnt
				FROM Organization_Users U
				WHERE U.Enabled = TRUE
				) T
				WHERE T.RowNum BETWEEN 
				((CurrentPageIndex - 1) * ViewCount) + 1 AND CurrentPageIndex * ViewCount
				ORDER BY SortNo,Name ASC
			END
			ELSE IF Sort = 2
			--직급정렬
			BEGIN
				RETURN QUERY
				SELECT UserNo,GroupName,Name,PosName,SortNo FROM 
				(SELECT ROW_NUMBER() OVER (ORDER BY (SELECT SortNo FROM Organization_Positions WHERE PositionNo IN (SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo=U.UserNo)) ASC) AS RowNum,
				U.UserNo,'' AS GroupName,U.Name,
				(SELECT SortNo FROM Organization_Positions WHERE PositionNo IN (SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo=U.UserNo)) AS SortNo,
				(SELECT Name FROM Organization_Positions WHERE PositionNo IN (SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo=U.UserNo)) AS PosName
				,(SELECT COUNT(*) FROM Organization_Users WHERE Enabled = TRUE) AS TotalCnt
				FROM Organization_Users U
				WHERE U.Enabled = TRUE
				) T
				WHERE T.RowNum BETWEEN 
				((CurrentPageIndex - 1) * ViewCount) + 1 AND CurrentPageIndex * ViewCount
				ORDER BY SortNo,Name ASC
			END
			ELSE IF Sort = 3
			--이름정렬
			BEGIN
				RETURN QUERY
				SELECT UserNo,GroupName,Name,PosName,SortNo FROM 
				(SELECT ROW_NUMBER() OVER (ORDER BY U.Name ASC) AS RowNum,
				U.UserNo,'' AS GroupName,U.Name,
				(SELECT SortNo FROM Organization_Positions WHERE PositionNo IN (SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo=U.UserNo)) AS SortNo,
				(SELECT Name FROM Organization_Positions WHERE PositionNo IN (SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo=U.UserNo)) AS PosName
				,(SELECT COUNT(*) FROM Organization_Users WHERE Enabled = TRUE) AS TotalCnt
				FROM Organization_Users U
				WHERE U.Enabled = TRUE
				) T
				WHERE T.RowNum BETWEEN 
				((CurrentPageIndex - 1) * ViewCount) + 1 AND CurrentPageIndex * ViewCount
				ORDER BY Name,SortNo ASC
			END
		END
		ELSE IF GetTabType = 2
		--가입된 부서톡 인원정보
		BEGIN
			IF Sort = 1
			--전체기본 정렬
			BEGIN
				RETURN QUERY
				SELECT UserNo,GroupName,Name,PosName,SortNo FROM
				(SELECT ROW_NUMBER() OVER (ORDER BY G.GroupName ASC) AS RowNum,
				GU.UserNo,G.GroupName,U.Name
				,(SELECT SortNo FROM Organization_Positions WHERE PositionNo IN (SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo=U.UserNo)) AS SortNo
				,(SELECT Name FROM Organization_Positions WHERE PositionNo IN (SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo=U.UserNo)) AS PosName
				,(SELECT COUNT(*) FROM SnsGroupUsers UU INNER JOIN SnsGroups GG ON GG.GroupNo=UU.GroupNo WHERE GG.GroupType=102 AND UU.GroupNo IN (SELECT GroupNo FROM SnsGroupUsers WHERE UserNo=sns_getpeoplelist.userno and IsJoin = TRUE)) AS TotalCnt
				FROM SnsGroupUsers GU
				INNER JOIN SnsGroups G ON G.GroupNo=GU.GroupNo
				INNER JOIN Organization_Users U ON U.UserNo = GU.UserNo AND U.Enabled = TRUE
				WHERE GU.GroupNo IN (SELECT GroupNo FROM SnsGroupUsers WHERE UserNo=sns_getpeoplelist.userno and IsJoin = TRUE)
				AND G.GroupType=102) T
				WHERE T.RowNum BETWEEN 
				((CurrentPageIndex - 1) * ViewCount) + 1 AND CurrentPageIndex * ViewCount
				ORDER BY GroupName,Name ASC
			END
			ELSE IF Sort = 2
			--직급정렬
			BEGIN
				RETURN QUERY
				SELECT UserNo,GroupName,Name,PosName,SortNo FROM
				(SELECT ROW_NUMBER() OVER (ORDER BY (SELECT SortNo FROM Organization_Positions WHERE PositionNo IN (SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo=U.UserNo)) ASC) AS RowNum,
				GU.UserNo,G.GroupName,U.Name
				,(SELECT SortNo FROM Organization_Positions WHERE PositionNo IN (SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo=U.UserNo)) AS SortNo,
				(SELECT Name FROM Organization_Positions WHERE PositionNo IN (SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo=U.UserNo)) AS PosName
				,(SELECT COUNT(*) FROM SnsGroupUsers UU INNER JOIN SnsGroups GG ON GG.GroupNo=UU.GroupNo WHERE GG.GroupType=102 AND UU.GroupNo IN (SELECT GroupNo FROM SnsGroupUsers WHERE UserNo=sns_getpeoplelist.userno and IsJoin = TRUE)) AS TotalCnt
				FROM SnsGroupUsers GU
				INNER JOIN SnsGroups G ON G.GroupNo=GU.GroupNo
				INNER JOIN Organization_Users U ON U.UserNo = GU.UserNo AND U.Enabled = TRUE
				WHERE GU.GroupNo IN (SELECT GroupNo FROM SnsGroupUsers WHERE UserNo=sns_getpeoplelist.userno and IsJoin = TRUE)
				AND G.GroupType=102) T
				WHERE T.RowNum BETWEEN 
				((CurrentPageIndex - 1) * ViewCount) + 1 AND CurrentPageIndex * ViewCount
				ORDER BY SortNo,GroupName ASC
			END
			ELSE IF Sort = 3
			--이름정렬
			BEGIN
				RETURN QUERY
				SELECT UserNo,GroupName,Name,PosName,SortNo FROM
				(SELECT ROW_NUMBER() OVER (ORDER BY U.Name ASC) AS RowNum,
				GU.UserNo,G.GroupName,U.Name
				,(SELECT SortNo FROM Organization_Positions WHERE PositionNo IN (SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo=U.UserNo)) AS SortNo,
				(SELECT Name FROM Organization_Positions WHERE PositionNo IN (SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo=U.UserNo)) AS PosName
				,(SELECT COUNT(*) FROM SnsGroupUsers UU INNER JOIN SnsGroups GG ON GG.GroupNo=UU.GroupNo WHERE GG.GroupType=102 AND UU.GroupNo IN (SELECT GroupNo FROM SnsGroupUsers WHERE UserNo=sns_getpeoplelist.userno and IsJoin = TRUE)) AS TotalCnt
				FROM SnsGroupUsers GU
				INNER JOIN SnsGroups G ON G.GroupNo=GU.GroupNo
				INNER JOIN Organization_Users U ON U.UserNo = GU.UserNo AND U.Enabled = TRUE
				WHERE GU.GroupNo IN (SELECT GroupNo FROM SnsGroupUsers WHERE UserNo=sns_getpeoplelist.userno and IsJoin = TRUE)
				AND G.GroupType=102) T
				WHERE T.RowNum BETWEEN 
				((CurrentPageIndex - 1) * ViewCount) + 1 AND CurrentPageIndex * ViewCount
				ORDER BY Name,GroupName ASC
			END
		END
		ELSE IF GetTabType = 3
		--가입된 우리톡 인원정보
		BEGIN
			IF Sort = 1
			--전체기본 정렬
			BEGIN
				RETURN QUERY
				SELECT UserNo,GroupName,Name,PosName,SortNo FROM
				(SELECT ROW_NUMBER() OVER (ORDER BY G.GroupName ASC) AS RowNum,
				GU.UserNo,G.GroupName,U.Name
				,(SELECT SortNo FROM Organization_Positions WHERE PositionNo IN (SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo=U.UserNo)) AS SortNo,
				(SELECT Name FROM Organization_Positions WHERE PositionNo IN (SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo=U.UserNo)) AS PosName
				,(SELECT COUNT(*) FROM SnsGroupUsers UU INNER JOIN SnsGroups GG ON GG.GroupNo=UU.GroupNo WHERE GG.GroupType=103 AND UU.GroupNo IN (SELECT GroupNo FROM SnsGroupUsers WHERE UserNo=sns_getpeoplelist.userno and IsJoin = TRUE)) AS TotalCnt
				FROM SnsGroupUsers GU
				INNER JOIN SnsGroups G ON G.GroupNo=GU.GroupNo
				INNER JOIN Organization_Users U ON U.UserNo = GU.UserNo AND U.Enabled = TRUE
				WHERE GU.GroupNo IN (SELECT GroupNo FROM SnsGroupUsers WHERE UserNo=sns_getpeoplelist.userno and IsJoin = TRUE)
				AND G.GroupType=103) T
				WHERE T.RowNum BETWEEN 
				((CurrentPageIndex - 1) * ViewCount) + 1 AND CurrentPageIndex * ViewCount
				ORDER BY GroupName,Name ASC
			END
			ELSE IF Sort = 2
			--직급정렬
			BEGIN
				RETURN QUERY
				SELECT UserNo,GroupName,Name,PosName,SortNo FROM
				(SELECT ROW_NUMBER() OVER (ORDER BY (SELECT SortNo FROM Organization_Positions WHERE PositionNo IN (SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo=U.UserNo)) ASC) AS RowNum,
				GU.UserNo,G.GroupName,U.Name
				,(SELECT SortNo FROM Organization_Positions WHERE PositionNo IN (SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo=U.UserNo)) AS SortNo,
				(SELECT Name FROM Organization_Positions WHERE PositionNo IN (SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo=U.UserNo)) AS PosName
				,(SELECT COUNT(*) FROM SnsGroupUsers UU INNER JOIN SnsGroups GG ON GG.GroupNo=UU.GroupNo WHERE GG.GroupType=103 AND UU.GroupNo IN (SELECT GroupNo FROM SnsGroupUsers WHERE UserNo=sns_getpeoplelist.userno and IsJoin = TRUE)) AS TotalCnt
				FROM SnsGroupUsers GU
				INNER JOIN SnsGroups G ON G.GroupNo=GU.GroupNo
				INNER JOIN Organization_Users U ON U.UserNo = GU.UserNo AND U.Enabled = TRUE
				WHERE GU.GroupNo IN (SELECT GroupNo FROM SnsGroupUsers WHERE UserNo=sns_getpeoplelist.userno and IsJoin = TRUE)
				AND G.GroupType=103) T
				WHERE T.RowNum BETWEEN 
				((CurrentPageIndex - 1) * ViewCount) + 1 AND CurrentPageIndex * ViewCount
				ORDER BY SortNo,GroupName ASC
			END
			ELSE IF Sort = 3
			--이름정렬
			BEGIN
				RETURN QUERY
				SELECT UserNo,GroupName,Name,PosName,SortNo FROM
				(SELECT ROW_NUMBER() OVER (ORDER BY U.Name ASC) AS RowNum,
				GU.UserNo,G.GroupName,U.Name
				,(SELECT SortNo FROM Organization_Positions WHERE PositionNo IN (SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo=U.UserNo)) AS SortNo,
				(SELECT Name FROM Organization_Positions WHERE PositionNo IN (SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo=U.UserNo)) AS PosName
				,(SELECT COUNT(*) FROM SnsGroupUsers UU INNER JOIN SnsGroups GG ON GG.GroupNo=UU.GroupNo WHERE GG.GroupType=103 AND UU.GroupNo IN (SELECT GroupNo FROM SnsGroupUsers WHERE UserNo=sns_getpeoplelist.userno and IsJoin = TRUE)) AS TotalCnt
				FROM SnsGroupUsers GU
				INNER JOIN SnsGroups G ON G.GroupNo=GU.GroupNo
				INNER JOIN Organization_Users U ON U.UserNo = GU.UserNo AND U.Enabled = TRUE
				WHERE GU.GroupNo IN (SELECT GroupNo FROM SnsGroupUsers WHERE UserNo=sns_getpeoplelist.userno and IsJoin = TRUE)
				AND G.GroupType=103) T
				WHERE T.RowNum BETWEEN 
				((CurrentPageIndex - 1) * ViewCount) + 1 AND CurrentPageIndex * ViewCount
				ORDER BY Name,GroupName ASC
			END
		END
	END
	ELSE
	BEGIN
		--카운터값을 가져온다.
		RETURN QUERY
		SELECT (SELECT COUNT(*) FROM Organization_Users WHERE Enabled = TRUE) AS UserCnt
,COUNT(*) AS DepartCnt,(SELECT COUNT(*) FROM SnsGroupUsers UU INNER JOIN SnsGroups GG ON GG.GroupNo=UU.GroupNo INNER JOIN Organization_Users U ON UU.UserNo=U.UserNo AND U.Enabled = TRUE WHERE GG.GroupType=103 AND UU.GroupNo IN (SELECT GroupNo FROM SnsGroupUsers WHERE UserNo=23 and IsJoin = TRUE)) AS GroupCnt FROM SnsGroupUsers UU INNER JOIN SnsGroups GG ON GG.GroupNo=UU.GroupNo INNER JOIN Organization_Users U ON UU.UserNo=U.UserNo AND U.Enabled = TRUE WHERE GG.GroupType=102 AND UU.GroupNo IN (SELECT GroupNo FROM SnsGroupUsers WHERE UserNo=sns_getpeoplelist.userno and IsJoin = TRUE)
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
