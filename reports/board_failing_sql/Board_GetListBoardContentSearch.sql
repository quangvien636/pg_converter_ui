-- ─── PROCEDURE→FUNCTION: board_getlistboardcontentsearch ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.board_getlistboardcontentsearch(integer, integer, integer, integer, character varying, integer, integer, character varying, character varying, integer, timestamp without time zone, timestamp without time zone, boolean, boolean, character varying);
CREATE OR REPLACE FUNCTION public.board_getlistboardcontentsearch(
    IN userno integer DEFAULT 70,
    IN boardno integer DEFAULT 1087,
    IN curentpage integer DEFAULT 1,
    IN pagesize integer DEFAULT 10,
    IN langcode character varying DEFAULT 'EN',
    IN filtertype integer DEFAULT 100,
    IN searchtype integer DEFAULT 0,
    IN searchvalue character varying DEFAULT '',
    IN sortcolumn character varying DEFAULT '',
    IN sorttype integer DEFAULT 0,
    IN fromdate timestamp without time zone DEFAULT '2015-07-08 00:00:01',
    IN todate timestamp without time zone DEFAULT '2022-07-09 00:00:01',
    IN isadmin boolean DEFAULT FALSE,
    IN titleeffect boolean DEFAULT TRUE,
    IN mgdepartment character varying DEFAULT ''
) RETURNS SETOF record
AS $function$
DECLARE
    query character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


RETURN QUERY
WITH PERMISSION AS (
	Select ItemNo ,AllowValue,AllowAccessNo 
	FROM Board_AllowAccess 
	WHERE ItemType=2 AND UserNo=board_getlistboardcontentsearch.userno
),
SHARE AS(
	SELECT U.UserNo ,BS.ContentNo
	FROM Board_Sharers BS
	INNER JOIN (
		SELECT U.UserNo,OP.DepartNo 
		FROM Organization_Users U 
		INNER JOIN Organization_BelongToDepartment OP ON OP.UserNo=U.UserNo
		WHERE U.UserNo=board_getlistboardcontentsearch.userno AND U.Enabled = TRUE
		) U ON U.UserNo=BS.UserNo OR U.DepartNo=BS.DepartNo
),
REP AS (SELECT BC.ContentNo,COUNT(BR.ReplyNo) AS ReplyCount
	FROM Board_Contents BC
	LEFT JOIN Board_Replies BR ON BR.ContentNo=BC.ContentNo
	WHERE (BC.BoardNo=board_getlistboardcontentsearch.boardno OR  BoardNo =0 ) AND BC.Enabled = TRUE
	GROUP BY BC.ContentNo
	),
VIEWED AS (SELECT DISTINCT UserNo,ContentNo
FROM Board_ViewedLogs 
WHERE UserNo=board_getlistboardcontentsearch.userno),
VIEWEDLIST AS (
	SELECT BV.ContentNo, COUNT(BV.UserNo) AS ViewedCount
	FROM Board_ViewedLogs BV 
	INNER JOIN Board_Contents BC ON BV.ContentNo=BC.ContentNo 
	LEFT JOIN SHARE S ON S.ContentNo=BV.ContentNo
	WHERE  BC.IsShareAll=TRUE OR COALESCE(S.ContentNo,0)!=0 OR BV.UserNo=BC.RegUserNo
	GROUP BY BV.ContentNo
),
TMP AS (
	SELECT BC.BoardNo,BC.ContentNo,BC.Title, BC.Content ,BC.IsFile,BC.ViewedCount,BC.RootId,BC.TitleEffect,BC.RegDate,--T.Url AS FileUrl,
	CASE WHEN STRPOS(B.Name, '{')>0 THEN (SELECT StringValue FROM ParseJson(B.Name)  WHERE NAME=board_getlistboardcontentsearch.langcode) ELSE B.Name END AS BoardName ,
	CASE LangCode WHEN 'EN' THEN  COALESCE(OU.Name_EN,OU.Name) WHEN 'VN' THEN  COALESCE(OU.Name_VN,OU.Name) WHEN 'CH' THEN COALESCE(OU.Name_CH,OU.Name)  WHEN 'JP' THEN COALESCE(OU.Name_JP,OU.Name) ELSE OU.Name END AS RegUserName,
	CASE LangCode WHEN 'EN' THEN  COALESCE(OP.Name_EN,OP.Name) WHEN 'VN' THEN  COALESCE(OP.Name_VN,OP.Name) WHEN 'CH' THEN COALESCE(OP.Name_CH,OP.Name)  WHEN 'JP' THEN COALESCE(OP.Name_JP,OP.Name) ELSE OP.Name END AS RegPositionName,
	CASE LangCode WHEN 'EN' THEN  COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN  COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name)  WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END AS RegDepartName,
	SUBSTRING(TO_CHAR(BC.RegDate, 'YYYY-MM-DD HH24:MI:SS'),3,14) as RegDateToString,
	CASE WHEN '2020-12-31'::timestamp> BC.RegDate OR(BV.ContentNo IS NOT NULL OR BC.RegUserNo=board_getlistboardcontentsearch.userno)  THEN TRUE ELSE FALSE END AS IsReaded ,
	ROW_NUMBER() OVER(PARTITION BY BC.Enabled  ORDER BY CASE WHEN SortType=0 AND SortColumn='' THEN BC.RootId END DESC,
		CASE WHEN SortType=0 AND SortColumn='' THEN  BC.ContentNo END ASC,
		CASE WHEN SortType=0 AND SortColumn='TITLE' THEN  BC.Title END ASC,
		CASE WHEN SortType=0 AND SortColumn='BOARD' THEN  CASE WHEN STRPOS(B.Name, '{')>0 THEN (SELECT StringValue FROM ParseJson(B.Name)  WHERE NAME=board_getlistboardcontentsearch.langcode) ELSE B.Name END END ASC,
		CASE WHEN SortType=0 AND SortColumn='REGUSER' THEN  CASE LangCode WHEN 'EN' THEN  COALESCE(OU.Name_EN,OU.Name) WHEN 'VN' THEN  COALESCE(OU.Name_VN,OU.Name) WHEN 'CH' THEN COALESCE(OU.Name_CH,OU.Name)  WHEN 'JP' THEN COALESCE(OU.Name_JP,OU.Name) ELSE OU.Name END END ASC,
		CASE WHEN SortType=0 AND SortColumn='DEPART' THEN  CASE LangCode WHEN 'EN' THEN  COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN  COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name)  WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END END ASC,
		CASE WHEN SortType=0 AND SortColumn='REGDATE' THEN BC.RegDate END ASC,
		CASE WHEN SortType=0 AND SortColumn='VIEWED' THEN  BC.ViewedCount END ASC,
		CASE WHEN SortType=1 AND SortColumn='TITLE' THEN  BC.Title END DESC,
		CASE WHEN SortType=1 AND SortColumn='BOARD' THEN  CASE WHEN STRPOS(B.Name, '{')>0 THEN (SELECT StringValue FROM ParseJson(B.Name)  WHERE NAME=board_getlistboardcontentsearch.langcode) ELSE B.Name END END DESC,
		CASE WHEN SortType=1 AND SortColumn='REGUSER' THEN   CASE LangCode WHEN 'EN' THEN  COALESCE(OU.Name_EN,OU.Name) WHEN 'VN' THEN  COALESCE(OU.Name_VN,OU.Name) WHEN 'CH' THEN COALESCE(OU.Name_CH,OU.Name)  WHEN 'JP' THEN COALESCE(OU.Name_JP,OU.Name) ELSE OU.Name END END DESC,
		CASE WHEN SortType=1 AND SortColumn='DEPART' THEN  CASE LangCode WHEN 'EN' THEN  COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN  COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name)  WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END END DESC,
		CASE WHEN SortType=1 AND SortColumn='REGDATE' THEN  BC.RegDate END DESC,
		CASE WHEN SortType=1 AND SortColumn='VIEWED' THEN  BC.ViewedCount END DESC
		) AS RowNumber,
	B.ViewMode AS BoardType,
	B.SpecType,
	CASE WHEN IsAdmin = TRUE OR P.AllowValue%2<>0 OR BC.RegUserNo=board_getlistboardcontentsearch.userno THEN TRUE ELSE FALSE END AS IsDelete ,
	BC.Type,
	BC.ErrorType,
	BC.PersonType,
	BC.VisitDate,
	BC.VisitCompleteDate,
	BC.ConstructionName,
	BC.ApplyTo,
	CASE WHEN BC.DateView IS NULL THEN NULL ELSE (BC.DateView::date - BC.RegDate::date)  END AS DayDateView
	FROM BOARD_CONTENTS BC
	--LEFT JOIN (SELECT ContentNo,Url,ROW_NUMBER() OVER(PARTITION BY ContentNo  ORDER BY ContentNo ASC) AS Rn FROM Board_Files ) T ON T.ContentNo=BC.ContentNo AND Rn=1
	LEFT JOIN Board_Boards B ON B.BoardNo=BC.BoardNo
	LEFT JOIN Organization_Users OU ON OU.UserNo = BC.RegUserNo
	LEFT JOIN Organization_Positions OP ON OP.PositionNo = BC.RegPositionNo
	LEFT JOIN Organization_Departments OD ON OD.DepartNo = BC.RegDepartNO
	LEFT JOIN VIEWED BV ON BV.ContentNo=BC.ContentNo
	LEFT JOIN PERMISSION P ON P.ItemNo=BC.BoardNo
	LEFT JOIN SHARE S ON S.ContentNo=BC.ContentNo
	WHERE (BC.BoardNo=board_getlistboardcontentsearch.boardno OR   (BoardNo =0 AND B.ViewMode=2)) 
 
	AND BC.Enabled = TRUE 
	AND BC.RegDate>=board_getlistboardcontentsearch.fromdate 
	AND BC.RegDate<=board_getlistboardcontentsearch.todate 
	AND (FilterType=100 OR (FilterType=1 AND BV.ContentNo IS NULL))
	AND (TitleEffect=1 OR (TitleEffect=0 AND TitleEffect=0))
	AND (COALESCE(MgDepartment,'')='' OR MgDepartment=BC.PersonType)
	AND (COALESCE(SearchValue,'')=''  
			OR(SearchType=0 AND BC.Title ILIKE '%' || SearchValue || '%')
			OR(SearchType=1 AND CASE LangCode WHEN 'EN' THEN  COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN  COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name)  WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END ILIKE '%' || SearchValue || '%')
			OR(SearchType=2 AND CASE LangCode WHEN 'EN' THEN  COALESCE(OU.Name_EN,OU.Name) WHEN 'VN' THEN  COALESCE(OU.Name_VN,OU.Name) WHEN 'CH' THEN COALESCE(OU.Name_CH,OU.Name)  WHEN 'JP' THEN COALESCE(OU.Name_JP,OU.Name) ELSE OU.Name END ILIKE '%' || SearchValue || '%')
			OR(SearchType=3 AND BC.Type= board_getlistboardcontentsearch.searchvalue)
			OR(SearchType=4 AND BC.Type ILIKE '%' || SearchValue || '%')
			OR(SearchType=5 AND BC.ErrorType ILIKE '%' || SearchValue || '%')
			OR(SearchType=6 AND BC.ApplyTo ILIKE '%' || SearchValue || '%')
			)
		-- CASE SearchType 
		--	WHEN 0 THEN BC.Title 
		--	WHEN 1 THEN CASE LangCode WHEN 'EN' THEN  COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN  COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name)  WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END 
		--	WHEN 2 THEN CASE LangCode WHEN 'EN' THEN  COALESCE(OU.Name_EN,OU.Name) WHEN 'VN' THEN  COALESCE(OU.Name_VN,OU.Name) WHEN 'CH' THEN COALESCE(OU.Name_CH,OU.Name)  WHEN 'JP' THEN COALESCE(OU.Name_JP,OU.Name) ELSE OU.Name END 
		--	WHEN 3 THEN BC.Type  
		--	ELSE CASE LangCode WHEN 'EN' THEN  COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN  COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name)  WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END  
		--END ILIKE '%' || SearchValue || '%')
	AND ( IsAdmin = TRUE OR BC.RegUserNo=board_getlistboardcontentsearch.userno OR  (P.AllowAccessNo IS NOT NULL AND B.SpecType=0) OR ((BC.IsShareAll = TRUE  OR S.ContentNo IS NOT NULL) AND  B.SpecType=1)
)
) ,
Total AS (Select MAX(RowNumber) as ToTal FROM TMP)
SELECT T.BoardNo,
T.ContentNo ,
T.Title,
T.Content,
F.Url AS FileUrl,
T.IsFile,
T.BoardName ,
T.RegUserName,
T.RegPositionName,
T.RegDepartName,
COALESCE(VL.ViewedCount,0) AS ViewedCount,
T.RegDateToString,
T.RootId,
T.TitleEffect,
T.IsDelete ,
T.IsReaded,
c.Total,
COALESCE(R.ReplyCount,0) AS ReplyCount,
T.BoardType,
T.RegDate,
T.Type,
	T.ErrorType,
	T.PersonType,
	T.VisitDate,
	T.VisitCompleteDate,
	T.ConstructionName,
	T.DayDateView,
	T.ApplyTo,
	c.Total -T.RowNumber +1 AS RowNumber
FROM TMP T  
LEFT JOIN Total c ON c.Total>0
LEFT JOIN (SELECT BR.ContentNo,COUNT(BR.ReplyNo) AS ReplyCount FROM Board_Replies BR GROUP BY BR.ContentNo)R ON R.ContentNo=T.ContentNo
LEFT JOIN (SELECT ContentNo,Url,ROW_NUMBER() OVER(PARTITION BY ContentNo  ORDER BY ContentNo ASC) AS Rn FROM Board_Files ) F ON F.ContentNo=T.ContentNo AND F.Rn=1
LEFT JOIN VIEWEDLIST VL ON VL.ContentNo=T.ContentNo
--INNER JOIN REP R ON R.ContentNo=T.ContentNo
WHERE   T.RowNumber>(CurentPage-1)*PageSize AND T.RowNumber<=board_getlistboardcontentsearch.curentpage*PageSize
ORDER BY T.RowNumber;
--	CASE WHEN SortType=0 AND SortColumn='' THEN T.RootId END DESC,
--	CASE WHEN SortType=0 AND SortColumn='' THEN  T.ContentNo END ASC,
--	CASE WHEN SortType=0 AND SortColumn='TITLE' THEN  T.Title END ASC,
--	CASE WHEN SortType=0 AND SortColumn='BOARD' THEN  T.BoardName END ASC,
--	CASE WHEN SortType=0 AND SortColumn='REGUSER' THEN  T.RegUserName END ASC,
--	CASE WHEN SortType=0 AND SortColumn='DEPART' THEN  T.RegDepartName END ASC,
--	CASE WHEN SortType=0 AND SortColumn='REGDATE' THEN  T.RegDateToString END ASC,
--	CASE WHEN SortType=0 AND SortColumn='VIEWED' THEN  T.ViewedCount END ASC,
--	CASE WHEN SortType=1 AND SortColumn='TITLE' THEN  T.Title END DESC,
--	CASE WHEN SortType=1 AND SortColumn='BOARD' THEN  T.BoardName END DESC,
--	CASE WHEN SortType=1 AND SortColumn='REGUSER' THEN  T.RegUserName END DESC,
--	CASE WHEN SortType=1 AND SortColumn='DEPART' THEN  T.RegDepartName END DESC,
--	CASE WHEN SortType=1 AND SortColumn='REGDATE' THEN  T.RegDateToString END DESC,
--	CASE WHEN SortType=1 AND SortColumn='VIEWED' THEN  T.ViewedCount END DESC
END;

--LEFT JOIN (SELECT BR.ContentNo,COUNT(BR.ReplyNo) AS ReplyCount FROM Board_Replies BR GROUP BY BR.ContentNo)R  ON R.ContentNo=T.ContentNo
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.