-- ─── FUNCTION: board_getlistboardcontenttoexcel ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_getlistboardcontenttoexcel(integer, character varying, integer, integer, character varying, integer, integer, character varying, character varying, integer, timestamp without time zone, timestamp without time zone, boolean, boolean, character varying, character varying);
CREATE OR REPLACE FUNCTION public.board_getlistboardcontenttoexcel(
    userno integer DEFAULT 70,
    boardlist character varying DEFAULT ',0',
    curentpage integer DEFAULT 1,
    pagesize integer DEFAULT 10,
    langcode character varying DEFAULT 'EN',
    filtertype integer DEFAULT 100,
    searchtype integer DEFAULT 0,
    searchvalue character varying DEFAULT '',
    sortcolumn character varying DEFAULT '',
    sorttype integer DEFAULT 0,
    fromdate timestamp without time zone DEFAULT '2011-01-01 19:20:19.717',
    todate timestamp without time zone DEFAULT '2033-09-30 19:20:19.717',
    isadmin boolean DEFAULT TRUE,
    titleeffect boolean DEFAULT FALSE,
    mgdepartment character varying DEFAULT '',
    contentnos character varying DEFAULT ''
) RETURNS TABLE(
    rownumber text,
    title text,
    content text,
    boardname text,
    regusername text,
    regpositionname text,
    regdepartname text,
    regdate text,
    moddate text,
    viewedcount text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

WITH PERMISSION AS (
	Select ItemNo ,AllowValue,AllowAccessNo
	FROM Board_AllowAccess 
	WHERE ItemType=2 AND UserNo=board_getlistboardcontenttoexcel.userno
),
DEPARTPERMISSION AS (
	Select ItemNo ,AllowValue,AllowAccessNo 
	FROM Board_DepartAllowAccess BD 
	INNER JOIN Organization_BelongToDepartment OB ON OB.DepartNo=BD.DepartNo
	WHERE BD.ItemType=2 AND OB.UserNo=board_getlistboardcontenttoexcel.userno AND OB.IsDefault= TRUE
),
SHARE AS(
	SELECT U.UserNo ,BS.ContentNo,ROW_NUMBER() OVER(PARTITION BY BS.ContentNo  ORDER BY BS.ContentNo ASC) AS Rn
	FROM Board_Sharers BS
	INNER JOIN (
		SELECT U.UserNo,OP.DepartNo
		FROM Organization_Users U 
		INNER JOIN Organization_BelongToDepartment OP ON OP.UserNo=U.UserNo
		WHERE U.UserNo=board_getlistboardcontenttoexcel.userno AND U.Enabled = TRUE
		) U ON U.UserNo=BS.UserNo OR U.DepartNo=BS.DepartNo
),
VIEWED AS (
	SELECT DISTINCT UserNo,ContentNo
	FROM Board_ViewedLogs 
	WHERE UserNo=board_getlistboardcontenttoexcel.userno),
VIEWEDLIST AS (
	SELECT BV.ContentNo, COUNT(BV.UserNo) AS ViewedCount
	FROM Board_ViewedLogs BV 
	INNER JOIN Board_Contents BC ON BV.ContentNo=BC.ContentNo 
	LEFT JOIN SHARE S ON S.ContentNo=BV.ContentNo
	WHERE  BC.IsShareAll=TRUE OR COALESCE(S.ContentNo,0)!=0 OR BV.UserNo=BC.RegUserNo
	GROUP BY BV.ContentNo
)
,TMP AS (
	SELECT BC.ContentNo, BC.Title,BC.ViewedCount,BC.RegDate,BC.ModDate,BC.RootId,
	SUBSTRING(TO_CHAR(BC.RegDate, 'YYYY-MM-DD HH24:MI:SS'),3,14) as RegDateToString,
	CASE WHEN '2020-12-31'::timestamp> BC.RegDate OR(BV.ContentNo IS NOT NULL OR BC.RegUserNo=board_getlistboardcontenttoexcel.userno) THEN TRUE ELSE FALSE END AS IsReaded ,
	CASE WHEN STRPOS(B.Name, '{')>0 THEN (SELECT /* /* TOP 1 */ */ StringValue FROM ParseJson(B.Name)  WHERE NAME=board_getlistboardcontenttoexcel.langcode) ELSE B.Name END AS BoardName ,
	CASE LangCode WHEN 'EN' THEN  COALESCE(OU.Name_EN,OU.Name) WHEN 'VN' THEN  COALESCE(OU.Name_VN,OU.Name) WHEN 'CH' THEN COALESCE(OU.Name_CH,OU.Name)  WHEN 'JP' THEN COALESCE(OU.Name_JP,OU.Name) ELSE OU.Name END AS RegUserName,
	CASE LangCode WHEN 'EN' THEN  COALESCE(OP.Name_EN,OP.Name) WHEN 'VN' THEN  COALESCE(OP.Name_VN,OP.Name) WHEN 'CH' THEN COALESCE(OP.Name_CH,OP.Name)  WHEN 'JP' THEN COALESCE(OP.Name_JP,OP.Name) ELSE OP.Name END AS RegPositionName,
	CASE LangCode WHEN 'EN' THEN  COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN  COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name)  WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END AS RegDepartName,
	ROW_NUMBER() OVER(PARTITION BY BC.Enabled  ORDER BY
		CASE WHEN SortType=0 AND SortColumn='' THEN BC.RootId END DESC,
		CASE WHEN SortType=0 AND SortColumn='' THEN BC.HeadNo END ASC,
		CASE WHEN SortType=0 AND SortColumn='' THEN  BC.ContentNo END ASC,
		CASE WHEN SortType=0 AND SortColumn='LISTSORT' THEN BC.IsNotice END DESC,
		CASE WHEN SortType=0 AND SortColumn='LISTSORT' THEN  BC.RootId END DESC,
		CASE WHEN SortType=0 AND SortColumn='LISTSORT' THEN BC.HeadNo END ASC,
		CASE WHEN SortType=0 AND SortColumn='LISTSORT' THEN  BC.ContentNo END ASC,
		CASE WHEN SortType=0 AND SortColumn='TITLE' THEN  BC.Title END ASC,
		CASE WHEN SortType=0 AND SortColumn='BOARD' THEN  CASE WHEN STRPOS(B.Name, '{')>0 THEN (SELECT /* /* TOP 1 */ */ StringValue FROM ParseJson(B.Name)  WHERE NAME=board_getlistboardcontenttoexcel.langcode) ELSE B.Name END END ASC,
		CASE WHEN SortType=0 AND SortColumn='REGUSER' THEN  CASE LangCode WHEN 'EN' THEN  COALESCE(OU.Name_EN,OU.Name) WHEN 'VN' THEN  COALESCE(OU.Name_VN,OU.Name) WHEN 'CH' THEN COALESCE(OU.Name_CH,OU.Name)  WHEN 'JP' THEN COALESCE(OU.Name_JP,OU.Name) ELSE OU.Name END END ASC,
		CASE WHEN SortType=0 AND SortColumn='DEPART' THEN  CASE LangCode WHEN 'EN' THEN  COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN  COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name)  WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END END ASC,
		CASE WHEN SortType=0 AND SortColumn='REGDATE' THEN BC.RegDate END ASC,
		CASE WHEN SortType=0 AND SortColumn='VIEWED' THEN  BC.ViewedCount END ASC,
		CASE WHEN SortType=1 AND SortColumn='TITLE' THEN  BC.Title END DESC,
		CASE WHEN SortType=1 AND SortColumn='BOARD' THEN  CASE WHEN STRPOS(B.Name, '{')>0 THEN (SELECT /* /* TOP 1 */ */ StringValue FROM ParseJson(B.Name)  WHERE NAME=board_getlistboardcontenttoexcel.langcode) ELSE B.Name END END DESC,
		CASE WHEN SortType=1 AND SortColumn='REGUSER' THEN   CASE LangCode WHEN 'EN' THEN  COALESCE(OU.Name_EN,OU.Name) WHEN 'VN' THEN  COALESCE(OU.Name_VN,OU.Name) WHEN 'CH' THEN COALESCE(OU.Name_CH,OU.Name)  WHEN 'JP' THEN COALESCE(OU.Name_JP,OU.Name) ELSE OU.Name END END DESC,
		CASE WHEN SortType=1 AND SortColumn='DEPART' THEN  CASE LangCode WHEN 'EN' THEN  COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN  COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name)  WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END END DESC,
		CASE WHEN SortType=1 AND SortColumn='REGDATE' THEN  BC.RegDate END DESC,
		CASE WHEN SortType=1 AND SortColumn='VIEWED' THEN  BC.ViewedCount END DESC
	) AS RowNumber,


	CASE WHEN BC.DateView IS NULL THEN NULL ELSE (BC.DateView::date - BC.RegDate::date)  END AS DayDateView,
	BC.Content
	FROM BOARD_CONTENTS BC
	LEFT JOIN Board_Boards B ON B.BoardNo=BC.BoardNo
	LEFT JOIN Organization_Users OU ON OU.UserNo = BC.RegUserNo
	--LEFT JOIN Organization_BelongToDepartment OB ON OB.UserNo=OU.UserNo
	LEFT JOIN Organization_Positions OP ON OP.PositionNo = BC.RegPositionNo
	LEFT JOIN Organization_Departments OD ON OD.DepartNo = BC.RegDepartNO
	LEFT JOIN VIEWED BV ON BV.ContentNo=BC.ContentNo
	LEFT JOIN PERMISSION P ON P.ItemNo=BC.BoardNo
	LEFT JOIN DEPARTPERMISSION D ON D.ItemNo=BC.BoardNo
	LEFT JOIN SHARE S ON S.ContentNo=BC.ContentNo And S.Rn=1
	WHERE (0 IN (SELECT * FROM fnStringToListInt(BoardList)) OR BC.BoardNo IN (SELECT * FROM fnStringToListInt(BoardList))) AND BC.Enabled = TRUE AND BC.RegDate>=board_getlistboardcontenttoexcel.fromdate AND BC.RegDate<=board_getlistboardcontenttoexcel.todate
	AND B.ViewMode>=2
	AND (FilterType=100 OR (FilterType=1 AND BV.ContentNo IS NULL))
	AND (TitleEffect=1 OR (TitleEffect=0 AND BC.TitleEffect=0))
	AND (COALESCE(MgDepartment,'')='' OR MgDepartment=BC.PersonType)
	AND (COALESCE(SearchValue,'')='' 
			OR(SearchType=0 AND BC.Title ILIKE '%' || SearchValue || '%')
			OR(SearchType=1 AND CASE LangCode WHEN 'EN' THEN  COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN  COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name)  WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END ILIKE '%' || SearchValue || '%')
			OR(SearchType=2 AND CASE LangCode WHEN 'EN' THEN  COALESCE(OU.Name_EN,OU.Name) WHEN 'VN' THEN  COALESCE(OU.Name_VN,OU.Name) WHEN 'CH' THEN COALESCE(OU.Name_CH,OU.Name)  WHEN 'JP' THEN COALESCE(OU.Name_JP,OU.Name) ELSE OU.Name END ILIKE '%' || SearchValue || '%')
			OR(SearchType=3 AND BC.Type= board_getlistboardcontenttoexcel.searchvalue)
			OR(SearchType=4 AND BC.Type ILIKE '%' || SearchValue || '%')
			OR(SearchType=5 AND BC.ErrorType ILIKE '%' || SearchValue || '%')
			OR(SearchType=6 AND BC.ApplyTo ILIKE '%' || SearchValue || '%')
			)
	AND ( IsAdmin = TRUE OR BC.RegUserNo=board_getlistboardcontenttoexcel.userno OR P.AllowValue=7 OR D.AllowValue=7 OR ((P.AllowAccessNo IS NOT NULL OR D.AllowAccessNo IS NOT NULL)AND  B.SpecType=0 AND (BC.IsShareAll = TRUE  OR S.ContentNo IS NOT NULL)) OR ((BC.IsShareAll = TRUE  OR S.ContentNo IS NOT NULL)AND  B.SpecType=1))
	AND (COALESCE(ContentNos,'')=''  OR BC.ContentNo IN (SELECT * FROM fnStringToListInt(ContentNos)))
) ,
Total AS (Select count(*) as ToTal FROM TMP)
RETURN QUERY
SELECT
c.Total -T.RowNumber +1 AS RowNumber,
T.Title,
COALESCE(T.Content,'') AS Content ,
COALESCE(T.BoardName,'') AS BoardName ,
(T.RegUserName || ' - ' || T.RegPositionName) AS  RegUserName,
COALESCE(T.RegPositionName,'') AS RegPositionName ,
COALESCE(T.RegDepartName,'') AS RegDepartName ,
T.RegDate,
T.ModDate,
COALESCE(VL.ViewedCount,0) AS ViewedCount

FROM TMP T  
LEFT JOIN Total c ON c.Total>0
LEFT JOIN VIEWEDLIST VL ON VL.ContentNo=T.ContentNo
--INNER JOIN REP R ON R.ContentNo=T.ContentNo
ORDER BY T.RowNumber;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
