-- ─── PROCEDURE→FUNCTION: sns_getpeoplelist ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.sns_getpeoplelist(integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.sns_getpeoplelist(
    IN userno integer,
    IN sort integer,
    IN currentpageindex integer,
    IN viewcount integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF GetTabType > 0 AND CurrentPageIndex > 0 AND ViewCount > 0 THEN
		IF GetTabType = 1 THEN
		--회사전체 인원정보
			IF Sort = 1 THEN
			--전체기본 정렬
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
			END IF;
			ELSIF Sort = 2 THEN
			--직급정렬
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
			END IF;
			ELSIF Sort = 3 THEN
			--이름정렬
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
			END IF;
		END IF;
		ELSIF GetTabType = 2 THEN
		--가입된 부서톡 인원정보
			IF Sort = 1 THEN
			--전체기본 정렬
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
			END IF;
			ELSIF Sort = 2 THEN
			--직급정렬
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
			END IF;
			ELSIF Sort = 3 THEN
			--이름정렬
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
			END IF;
		END IF;
		ELSIF GetTabType = 3 THEN
		--가입된 우리톡 인원정보
			IF Sort = 1 THEN
			--전체기본 정렬
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
			END IF;
			ELSIF Sort = 2 THEN
			--직급정렬
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
			END IF;
			ELSIF Sort = 3 THEN
			--이름정렬
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
			END IF;
		END IF;
	END IF;
	ELSE
		--카운터값을 가져온다.
		RETURN QUERY
		SELECT (SELECT COUNT(*) FROM Organization_Users WHERE Enabled = TRUE) AS UserCnt
,COUNT(*) AS DepartCnt,(SELECT COUNT(*) FROM SnsGroupUsers UU INNER JOIN SnsGroups GG ON GG.GroupNo=UU.GroupNo INNER JOIN Organization_Users U ON UU.UserNo=U.UserNo AND U.Enabled = TRUE WHERE GG.GroupType=103 AND UU.GroupNo IN (SELECT GroupNo FROM SnsGroupUsers WHERE UserNo=23 and IsJoin = TRUE)) AS GroupCnt FROM SnsGroupUsers UU INNER JOIN SnsGroups GG ON GG.GroupNo=UU.GroupNo INNER JOIN Organization_Users U ON UU.UserNo=U.UserNo AND U.Enabled = TRUE WHERE GG.GroupType=102 AND UU.GroupNo IN (SELECT GroupNo FROM SnsGroupUsers WHERE UserNo=sns_getpeoplelist.userno and IsJoin = TRUE)
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
