-- ─── PROCEDURE→FUNCTION: sns_getuserlisttogroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.sns_getuserlisttogroup(integer, integer, integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.sns_getuserlisttogroup(
    IN groupno integer,
    IN userno integer,
    IN currentpageindex integer,
    IN viewcount integer,
    IN mode integer,
    IN grouptype integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	
	IF Mode = 0 THEN
    	RETURN QUERY
    	SELECT UserNo,GroupName,Name,PosName,SortNo,IsMaker,TotalCnt FROM
		(SELECT ROW_NUMBER() OVER (ORDER BY (SELECT SortNo FROM Organization_Positions WHERE PositionNo IN (SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo=U.UserNo))) AS RowNum,
		GU.UserNo,G.GroupName,U.Name
		,(SELECT SortNo FROM Organization_Positions WHERE PositionNo IN (SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo=U.UserNo)) AS SortNo,
		(SELECT Name FROM Organization_Positions WHERE PositionNo IN (SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo=U.UserNo)) AS PosName
		,(SELECT COUNT(*) FROM SnsGroupUsers UU INNER JOIN SnsGroups GG ON GG.GroupNo=UU.GroupNo WHERE GG.GroupType=103 AND UU.GroupNo = sns_getuserlisttogroup.groupno) AS TotalCnt
		,G.MakeUserNo
		,(CASE WHEN G.MakeUserNo = GU.UserNo THEN '0' ELSE '1' END) AS IsMaker
		FROM SnsGroupUsers GU
		INNER JOIN SnsGroups G ON G.GroupNo=GU.GroupNo
		INNER JOIN Organization_Users U ON U.UserNo = GU.UserNo
		WHERE GU.GroupNo = sns_getuserlisttogroup.groupno
		AND G.GroupType=103
		AND U.Enabled = TRUE
		) T
		WHERE T.RowNum BETWEEN 
		((CurrentPageIndex - 1) * ViewCount) + 1 AND CurrentPageIndex * ViewCount
		ORDER BY IsMaker,SortNo,Name ASC
	END IF;
	ELSIF Mode = 1 THEN
		IF GroupType = 0		-- 일반 그룹톡 THEN
			RETURN QUERY
			SELECT UserNo,GroupName,Name,PosName,SortNo,IsMaker,TotalCnt FROM
			(SELECT ROW_NUMBER() OVER (ORDER BY (SELECT SortNo FROM Organization_Positions WHERE PositionNo IN (SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo=U.UserNo))) AS RowNum,
			GU.UserNo,G.GroupName,U.Name
			,(SELECT SortNo FROM Organization_Positions WHERE PositionNo IN (SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo=U.UserNo)) AS SortNo,
			(SELECT Name FROM Organization_Positions WHERE PositionNo IN (SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo=U.UserNo)) AS PosName
			,(SELECT COUNT(*) FROM SnsGroupUsers UU INNER JOIN SnsGroups GG ON GG.GroupNo=UU.GroupNo WHERE UU.GroupNo = sns_getuserlisttogroup.groupno) AS TotalCnt
			,G.MakeUserNo
			,(CASE WHEN G.MakeUserNo = GU.UserNo THEN '0' ELSE '1' END) AS IsMaker
			FROM SnsGroupUsers GU
			INNER JOIN SnsGroups G ON G.GroupNo=GU.GroupNo
			INNER JOIN Organization_Users U ON U.UserNo = GU.UserNo
			WHERE GU.GroupNo = sns_getuserlisttogroup.groupno
			AND U.Enabled = TRUE
			) T ORDER BY GroupName,SortNo,Name ASC
		END IF;
		ELSIF GroupType = 1	-- 최신톡 THEN
			RETURN QUERY
			SELECT UserNo,GroupName,Name,PosName,SortNo,IsMaker,TotalCnt FROM
			(SELECT ROW_NUMBER() OVER (ORDER BY (SELECT SortNo FROM Organization_Positions WHERE PositionNo IN (SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo=U.UserNo))) AS RowNum,
			GU.UserNo,G.GroupName,U.Name
			,(SELECT SortNo FROM Organization_Positions WHERE PositionNo IN (SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo=U.UserNo)) AS SortNo,
			(SELECT Name FROM Organization_Positions WHERE PositionNo IN (SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo=U.UserNo)) AS PosName
			,(SELECT COUNT(*) FROM SnsGroupUsers UU INNER JOIN SnsGroups GG ON GG.GroupNo=UU.GroupNo WHERE UU.GroupNo IN (SELECT GroupNo FROM SnsGroupUsers WHERE UserNo=sns_getuserlisttogroup.userno AND IsJoin = TRUE)) AS TotalCnt
			,G.MakeUserNo
			,(CASE WHEN G.MakeUserNo = GU.UserNo THEN '0' ELSE '1' END) AS IsMaker
			FROM SnsGroupUsers GU
			INNER JOIN SnsGroups G ON G.GroupNo=GU.GroupNo
			INNER JOIN Organization_Users U ON U.UserNo = GU.UserNo
			WHERE GU.GroupNo IN (SELECT GroupNo FROM SnsGroupUsers WHERE UserNo=sns_getuserlisttogroup.userno AND IsJoin = TRUE) 
			AND U.Enabled = TRUE
			) T ORDER BY GroupName,SortNo,Name ASC
		END IF;
		ELSIF GroupType = 2	-- 개인톡 THEN
			RETURN QUERY
			SELECT UserNo,GroupName,Name,PosName,SortNo,IsMaker,TotalCnt FROM
			((SELECT GU.UserNo,G.GroupName,U.Name
			,(SELECT SortNo FROM Organization_Positions WHERE PositionNo IN (SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo=U.UserNo)) AS SortNo,
			(SELECT Name FROM Organization_Positions WHERE PositionNo IN (SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo=U.UserNo)) AS PosName
			,(SELECT COUNT(*) FROM SnsGroupUsers UU INNER JOIN SnsGroups GG ON GG.GroupNo=UU.GroupNo WHERE UU.GroupNo = sns_getuserlisttogroup.groupno) AS TotalCnt
			,G.MakeUserNo
			,(CASE WHEN G.MakeUserNo = GU.UserNo THEN '0' ELSE '1' END) AS IsMaker
			FROM SnsGroupUsers GU
			INNER JOIN SnsGroups G ON G.GroupNo=GU.GroupNo
			INNER JOIN Organization_Users U ON U.UserNo = GU.UserNo
			WHERE GU.GroupNo IN (SELECT GroupNo FROM SnsGroupUsers WHERE UserNo=sns_getuserlisttogroup.userno AND IsJoin = TRUE)
			AND GU.GroupNo != (SELECT GroupNo FROM SnsGroups WHERE GroupType=104 AND MakeUserNo=sns_getuserlisttogroup.userno) 
			AND U.Enabled = TRUE
			)
			UNION ALL
			(SELECT GU.UserNo,G.GroupName,U.Name
			,(SELECT SortNo FROM Organization_Positions WHERE PositionNo IN (SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo=U.UserNo)) AS SortNo,
			(SELECT Name FROM Organization_Positions WHERE PositionNo IN (SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo=U.UserNo)) AS PosName
			,(SELECT COUNT(*) FROM SnsGroupUsers UU INNER JOIN SnsGroups GG ON GG.GroupNo=UU.GroupNo WHERE UU.GroupNo = sns_getuserlisttogroup.groupno) AS TotalCnt
			,G.MakeUserNo
			,(CASE WHEN G.MakeUserNo = GU.UserNo THEN '0' ELSE '1' END) AS IsMaker
			FROM SnsGroupUsers GU
			INNER JOIN SnsGroups G ON G.GroupNo=GU.GroupNo
			INNER JOIN Organization_Users U ON U.UserNo = GU.UserNo
			WHERE GU.GroupNo = (SELECT GroupNo FROM SnsGroups WHERE GroupType=104 AND MakeUserNo=sns_getuserlisttogroup.userno) 
			AND U.Enabled = TRUE
			)) T
			ORDER BY GroupName,SortNo,Name ASC
		END IF;
		ELSIF GroupType = 3	-- 즐겨찾기 THEN
			RETURN QUERY
			SELECT UserNo,GroupName,Name,PosName,SortNo,IsMaker,TotalCnt FROM
			(SELECT ROW_NUMBER() OVER (ORDER BY (SELECT SortNo FROM Organization_Positions WHERE PositionNo IN (SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo=U.UserNo))) AS RowNum,
			GU.UserNo,G.GroupName,U.Name
			,(SELECT SortNo FROM Organization_Positions WHERE PositionNo IN (SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo=U.UserNo)) AS SortNo,
			(SELECT Name FROM Organization_Positions WHERE PositionNo IN (SELECT PositionNo FROM Organization_BelongToDepartment WHERE UserNo=U.UserNo)) AS PosName
			,(SELECT COUNT(*) FROM SnsGroupUsers UU INNER JOIN SnsGroups GG ON GG.GroupNo=UU.GroupNo WHERE UU.GroupNo IN (SELECT GroupNo FROM SnsGroupUsers WHERE UserNo=sns_getuserlisttogroup.userno AND IsBookmark = TRUE AND IsJoin = TRUE) ) AS TotalCnt
			,G.MakeUserNo
			,(CASE WHEN G.MakeUserNo = GU.UserNo THEN '0' ELSE '1' END) AS IsMaker
			FROM SnsGroupUsers GU
			INNER JOIN SnsGroups G ON G.GroupNo=GU.GroupNo
			INNER JOIN Organization_Users U ON U.UserNo = GU.UserNo
			WHERE GU.GroupNo IN (SELECT GroupNo FROM SnsGroupUsers WHERE UserNo=sns_getuserlisttogroup.userno AND IsBookmark = TRUE AND IsJoin = TRUE) 
			AND U.Enabled = TRUE
			) T ORDER BY GroupName,SortNo,Name ASC
		END IF;
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
