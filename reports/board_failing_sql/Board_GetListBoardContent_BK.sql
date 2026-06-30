-- ─── PROCEDURE→FUNCTION: board_getlistboardcontent_bk ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.board_getlistboardcontent_bk(integer, integer, integer, integer, character varying, integer, integer, character varying, character varying, integer, timestamp without time zone, timestamp without time zone, boolean, boolean, character varying);
CREATE OR REPLACE FUNCTION public.board_getlistboardcontent_bk(
    IN userno integer DEFAULT 70,
    IN boardno integer DEFAULT 1094,
    IN curentpage integer DEFAULT 1,
    IN pagesize integer DEFAULT 15,
    IN langcode character varying DEFAULT 'EN',
    IN filtertype integer DEFAULT 100,
    IN searchtype integer DEFAULT 0,
    IN searchvalue character varying DEFAULT '',
    IN sortcolumn character varying DEFAULT '',
    IN sorttype integer DEFAULT 0,
    IN fromdate timestamp without time zone DEFAULT '2000-07-08 00:00:01',
    IN todate timestamp without time zone DEFAULT '2026-07-09 00:00:01',
    IN isadmin boolean DEFAULT TRUE,
    IN titleeffect boolean DEFAULT FALSE,
    IN mgdepartment character varying DEFAULT ''
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

IF BoardNo=0 THEN
RETURN QUERY
WITH PERMISSION AS (
	Select ItemNo ,AllowValue,AllowAccessNo 
	FROM Board_AllowAccess 
	WHERE ItemType=2 AND UserNo=board_getlistboardcontent_bk.userno AND AllowValue>0
),DEPARTPERMISSION AS (
	Select ItemNo ,AllowValue,AllowAccessNo 
	FROM Board_DepartAllowAccess BD 
	INNER JOIN Organization_BelongToDepartment OB ON OB.DepartNo=BD.DepartNo
	WHERE BD.ItemType=2 AND OB.UserNo=board_getlistboardcontent_bk.userno AND OB.IsDefault= TRUE AND BD.AllowValue>0
),
SHARE AS(
	SELECT U.UserNo ,BS.ContentNo,ROW_NUMBER() OVER(PARTITION BY BS.ContentNo  ORDER BY BS.ContentNo ASC) AS Rn
	FROM Board_Sharers BS
	INNER JOIN (
		SELECT U.UserNo,OP.DepartNo 
		FROM Organization_Users U 
		INNER JOIN Organization_BelongToDepartment OP ON OP.UserNo=U.UserNo
		WHERE U.UserNo=board_getlistboardcontent_bk.userno AND U.Enabled = TRUE
		) U ON U.UserNo=BS.UserNo OR U.DepartNo=BS.DepartNo
),
--REP AS (SELECT BC.ContentNo,COUNT(BR.ReplyNo) AS ReplyCount
--	FROM Board_Contents BC
--	LEFT JOIN Board_Replies BR ON BR.ContentNo=BC.ContentNo
--	WHERE (BC.BoardNo=BoardNo OR  BoardNo =0 ) AND BC.Enabled = TRUE
--	GROUP BY BC.ContentNo
--	),
PERMISSION_BOARD AS (SELECT B.BoardNo, B.Name,B.ViewMode,B.SpecType
	FROM Board_Boards B 
	LEFT JOIN PERMISSION P ON P.ItemNo=B.BoardNo 
	LEFT JOIN DEPARTPERMISSION D ON D.ItemNo=B.BoardNo 
	WHERE (B.BoardNo=board_getlistboardcontent_bk.boardno OR  BoardNo =0 ) AND ( IsAdmin = TRUE   OR P.AllowValue >0 OR  D.AllowValue >0 OR B.SpecType=1
	) 
	),
VIEWED AS (SELECT DISTINCT UserNo,ContentNo
FROM Board_ViewedLogs 
WHERE UserNo=board_getlistboardcontent_bk.userno),
VIEWEDLIST AS (
	SELECT DISTINCT BV.ContentNo, COUNT(BV.UserNo) AS ViewedCount
	FROM (SELECT DISTINCT ContentNo,UserNo FROM Board_ViewedLogs)  BV 
	INNER JOIN Board_Contents BC ON BV.ContentNo=BC.ContentNo 
	INNER JOIN Board_Boards BB ON BB.BoardNo=BC.BoardNo
	LEFT JOIN SHARE S ON S.ContentNo=BV.ContentNo AND S.Rn=1
	WHERE  BB.SpecType=1 OR  BC.IsShareAll=TRUE OR COALESCE(S.ContentNo,0)!=0 OR BV.UserNo=BC.RegUserNo 
	GROUP BY BV.ContentNo
),
TMP AS (
	SELECT BC.BoardNo,BC.ContentNo,BC.Title,BC.IsFile,BC.ViewedCount,BC.RootId,BC.TitleEffect,BC.RegDate,BC.ModDate,BC.IsNotice,--T.Url AS FileUrl,
	CASE WHEN STRPOS(B.Name, '{')>0 THEN (SELECT StringValue FROM ParseJson(B.Name)  WHERE NAME=board_getlistboardcontent_bk.langcode) ELSE B.Name END AS BoardName ,
	CASE LangCode WHEN 'EN' THEN  COALESCE(OU.Name_EN,OU.Name) WHEN 'VN' THEN  COALESCE(OU.Name_VN,OU.Name) WHEN 'CH' THEN COALESCE(OU.Name_CH,OU.Name)  WHEN 'JP' THEN COALESCE(OU.Name_JP,OU.Name) ELSE OU.Name END AS RegUserName,
	CASE LangCode WHEN 'EN' THEN  COALESCE(OP.Name_EN,OP.Name) WHEN 'VN' THEN  COALESCE(OP.Name_VN,OP.Name) WHEN 'CH' THEN COALESCE(OP.Name_CH,OP.Name)  WHEN 'JP' THEN COALESCE(OP.Name_JP,OP.Name) ELSE OP.Name END AS RegPositionName,
	CASE LangCode WHEN 'EN' THEN  COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN  COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name)  WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END AS RegDepartName,
	SUBSTRING(TO_CHAR(BC.RegDate, 'YYYY-MM-DD HH24:MI:SS'),3,14) as RegDateToString,
	CASE WHEN '2020-12-31'::timestamp> BC.RegDate OR(BV.ContentNo IS NOT NULL OR BC.RegUserNo=board_getlistboardcontent_bk.userno)  THEN TRUE ELSE FALSE END AS IsReaded ,
	ROW_NUMBER() OVER(PARTITION BY BC.Enabled  ORDER BY 
		CASE WHEN SortType=0 AND SortColumn='' THEN BC.RootId END DESC,
		CASE WHEN SortType=0 AND SortColumn='' THEN BC.HeadNo END ASC,
		CASE WHEN SortType=0 AND SortColumn='' THEN  BC.ContentNo END ASC,
		CASE WHEN SortType=0 AND SortColumn='LISTSORT' THEN BC.IsNotice END DESC,
		CASE WHEN SortType=0 AND SortColumn='LISTSORT' THEN  BC.RootId END DESC,
		CASE WHEN SortType=0 AND SortColumn='LISTSORT' THEN BC.HeadNo END ASC,
		CASE WHEN SortType=0 AND SortColumn='LISTSORT' THEN  BC.ContentNo END ASC,
		CASE WHEN SortType=0 AND SortColumn='TITLE' THEN  BC.Title END ASC,
		CASE WHEN SortType=0 AND SortColumn='BOARD' THEN  CASE WHEN STRPOS(B.Name, '{')>0 THEN (SELECT StringValue FROM ParseJson(B.Name)  WHERE NAME=board_getlistboardcontent_bk.langcode) ELSE B.Name END END ASC,
		CASE WHEN SortType=0 AND SortColumn='REGUSER' THEN  CASE LangCode WHEN 'EN' THEN  COALESCE(OU.Name_EN,OU.Name) WHEN 'VN' THEN  COALESCE(OU.Name_VN,OU.Name) WHEN 'CH' THEN COALESCE(OU.Name_CH,OU.Name)  WHEN 'JP' THEN COALESCE(OU.Name_JP,OU.Name) ELSE OU.Name END END ASC,
		CASE WHEN SortType=0 AND SortColumn='DEPART' THEN  CASE LangCode WHEN 'EN' THEN  COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN  COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name)  WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END END ASC,
		CASE WHEN SortType=0 AND SortColumn='REGDATE' THEN BC.RegDate END ASC,
		CASE WHEN SortType=0 AND SortColumn='VIEWED' THEN  BC.ViewedCount END ASC,
		CASE WHEN SortType=0 AND SortColumn='TYPE' THEN  BC.Type END ASC,
		CASE WHEN SortType=0 AND SortColumn='ERRORTYPE' THEN  BC.ErrorType END ASC,
		CASE WHEN SortType=0 AND SortColumn='PERSONTYPE' THEN  BC.PersonType END ASC,
		CASE WHEN SortType=1 AND SortColumn='TITLE' THEN  BC.Title END DESC,
		CASE WHEN SortType=1 AND SortColumn='BOARD' THEN  CASE WHEN STRPOS(B.Name, '{')>0 THEN (SELECT StringValue FROM ParseJson(B.Name)  WHERE NAME=board_getlistboardcontent_bk.langcode) ELSE B.Name END END DESC,
		CASE WHEN SortType=1 AND SortColumn='REGUSER' THEN   CASE LangCode WHEN 'EN' THEN  COALESCE(OU.Name_EN,OU.Name) WHEN 'VN' THEN  COALESCE(OU.Name_VN,OU.Name) WHEN 'CH' THEN COALESCE(OU.Name_CH,OU.Name)  WHEN 'JP' THEN COALESCE(OU.Name_JP,OU.Name) ELSE OU.Name END END DESC,
		CASE WHEN SortType=1 AND SortColumn='DEPART' THEN  CASE LangCode WHEN 'EN' THEN  COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN  COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name)  WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END END DESC,
		CASE WHEN SortType=1 AND SortColumn='REGDATE' THEN  BC.RegDate END DESC,
		CASE WHEN SortType=1 AND SortColumn='VIEWED' THEN  BC.ViewedCount END DESC,
		CASE WHEN SortType=1 AND SortColumn='TYPE' THEN  BC.Type END DESC,
		CASE WHEN SortType=1 AND SortColumn='ERRORTYPE' THEN  BC.ErrorType END DESC,
		CASE WHEN SortType=1 AND SortColumn='PERSONTYPE' THEN  BC.PersonType END DESC
		) AS RowNumber,
	B.ViewMode AS BoardType,
	B.SpecType,
	CASE WHEN IsAdmin = TRUE OR P.AllowValue%2<>0 OR D.AllowValue%2<>0 OR BC.RegUserNo=board_getlistboardcontent_bk.userno THEN TRUE ELSE FALSE END AS IsDelete 

	FROM BOARD_CONTENTS BC
	--LEFT JOIN (SELECT ContentNo,Url,ROW_NUMBER() OVER(PARTITION BY ContentNo  ORDER BY ContentNo ASC) AS Rn FROM Board_Files ) T ON T.ContentNo=BC.ContentNo AND Rn=1
	INNER JOIN PERMISSION_BOARD B ON B.BoardNo=BC.BoardNo
	LEFT JOIN Organization_Users OU ON OU.UserNo = BC.RegUserNo
	LEFT JOIN Organization_Positions OP ON OP.PositionNo = BC.RegPositionNo
	LEFT JOIN Organization_Departments OD ON OD.DepartNo = BC.RegDepartNO
	LEFT JOIN VIEWED BV ON BV.ContentNo=BC.ContentNo
	LEFT JOIN PERMISSION P ON P.ItemNo=BC.BoardNo 
	LEFT JOIN DEPARTPERMISSION D ON D.ItemNo=BC.BoardNo 
	LEFT JOIN SHARE S ON S.ContentNo=BC.ContentNo AND S.Rn=1
	WHERE (BC.BoardNo=board_getlistboardcontent_bk.boardno OR   (BoardNo =0 AND B.ViewMode>=2)) 
 
	AND BC.Enabled = TRUE 
	AND BC.RegDate>=board_getlistboardcontent_bk.fromdate 
	AND BC.RegDate<=board_getlistboardcontent_bk.todate 
	AND (FilterType=100 OR (FilterType=1 AND BV.ContentNo IS NULL))
	AND (TitleEffect=1 OR (TitleEffect=0 AND TitleEffect=0))
	AND (COALESCE(MgDepartment,'')='' OR MgDepartment=BC.PersonType)
	AND (COALESCE(SearchValue,'')=''  
			OR(SearchType=0 AND BC.Title ILIKE '%' || SearchValue || '%')
			OR(SearchType=1 AND CASE LangCode WHEN 'EN' THEN  COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN  COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name)  WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END ILIKE '%' || SearchValue || '%')
			OR(SearchType=2 AND CASE LangCode WHEN 'EN' THEN  COALESCE(OU.Name_EN,OU.Name) WHEN 'VN' THEN  COALESCE(OU.Name_VN,OU.Name) WHEN 'CH' THEN COALESCE(OU.Name_CH,OU.Name)  WHEN 'JP' THEN COALESCE(OU.Name_JP,OU.Name) ELSE OU.Name END ILIKE '%' || SearchValue || '%')
			OR(SearchType=3 AND BC.Type= board_getlistboardcontent_bk.searchvalue)
			OR(SearchType=4 AND BC.Type ILIKE '%' || SearchValue || '%')
			OR(SearchType=5 AND BC.ErrorType ILIKE '%' || SearchValue || '%')
			OR(SearchType=6 AND BC.ApplyTo ILIKE '%' || SearchValue || '%')
			OR(SearchType=7 AND BC.ConstructionName ILIKE '%' || SearchValue || '%')
			)
		-- CASE SearchType 
		--	WHEN 0 THEN BC.Title 
		--	WHEN 1 THEN CASE LangCode WHEN 'EN' THEN  COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN  COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name)  WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END 
		--	WHEN 2 THEN CASE LangCode WHEN 'EN' THEN  COALESCE(OU.Name_EN,OU.Name) WHEN 'VN' THEN  COALESCE(OU.Name_VN,OU.Name) WHEN 'CH' THEN COALESCE(OU.Name_CH,OU.Name)  WHEN 'JP' THEN COALESCE(OU.Name_JP,OU.Name) ELSE OU.Name END 
		--	WHEN 3 THEN BC.Type  
		--	ELSE CASE LangCode WHEN 'EN' THEN  COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN  COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name)  WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END  
		--END ILIKE '%' || SearchValue || '%')
	AND ( IsAdmin = TRUE OR BC.RegUserNo=board_getlistboardcontent_bk.userno  OR P.AllowValue=7 OR  D.AllowValue=7 OR ((P.AllowAccessNo IS NOT NULL OR D.AllowAccessNo IS NOT NULL)AND B.SpecType=0 AND (BC.IsShareAll = TRUE  OR S.ContentNo IS NOT NULL)) OR ((BC.IsShareAll = TRUE  OR S.ContentNo IS NOT NULL) AND  B.SpecType=1)
)
) ,
Total AS (Select MAX(RowNumber) as ToTal FROM TMP)
SELECT T.BoardNo,
T.ContentNo ,
T.Title,
COALESCE(F.Url,'') AS FileUrl,
F.Name AS FileName,
REPLACE(REPLACE(COALESCE(F.Url,''), '/Attach/', '/Thumbnail/'),'/File/','/Thumbnail/') AS ThumbnailFileUrl,
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
T.ModDate,
	T.IsNotice,
	c.Total -T.RowNumber +1 AS RowNumber
FROM TMP T  
LEFT JOIN Total c ON c.Total>0
LEFT JOIN (SELECT BR.ContentNo,COUNT(BR.ReplyNo) AS ReplyCount FROM Board_Replies BR GROUP BY BR.ContentNo)R ON R.ContentNo=T.ContentNo
LEFT JOIN (SELECT ContentNo,Url,Name,ROW_NUMBER() OVER(PARTITION BY ContentNo  ORDER BY ContentNo ASC) AS Rn FROM Board_Files ) F ON F.ContentNo=T.ContentNo AND F.Rn=1
LEFT JOIN VIEWEDLIST VL ON VL.ContentNo=T.ContentNo
--INNER JOIN REP R ON R.ContentNo=T.ContentNo
WHERE   T.RowNumber>(CurentPage-1)*PageSize AND T.RowNumber<=board_getlistboardcontent_bk.curentpage*PageSize
ORDER BY T.RowNumber;

ELSE
RETURN QUERY
WITH PERMISSION AS (
	Select ItemNo ,AllowValue,AllowAccessNo 
	FROM Board_AllowAccess 
	WHERE ItemType=2 AND UserNo=board_getlistboardcontent_bk.userno AND AllowValue>0
),DEPARTPERMISSION AS (
	Select ItemNo ,AllowValue,AllowAccessNo 
	FROM Board_DepartAllowAccess BD 
	INNER JOIN Organization_BelongToDepartment OB ON OB.DepartNo=BD.DepartNo
	WHERE BD.ItemType=2 AND OB.UserNo=board_getlistboardcontent_bk.userno AND OB.IsDefault= TRUE AND BD.AllowValue>0
),
SHARE AS(
	SELECT U.UserNo ,BS.ContentNo,ROW_NUMBER() OVER(PARTITION BY BS.ContentNo  ORDER BY BS.ContentNo ASC) AS Rn
	FROM Board_Sharers BS
	INNER JOIN (
		SELECT U.UserNo,OP.DepartNo 
		FROM Organization_Users U 
		INNER JOIN Organization_BelongToDepartment OP ON OP.UserNo=U.UserNo
		WHERE U.UserNo=board_getlistboardcontent_bk.userno AND U.Enabled = TRUE
		) U ON U.UserNo=BS.UserNo OR U.DepartNo=BS.DepartNo
),
--REP AS (SELECT BC.ContentNo,COUNT(BR.ReplyNo) AS ReplyCount
--	FROM Board_Contents BC
--	LEFT JOIN Board_Replies BR ON BR.ContentNo=BC.ContentNo
--	WHERE (BC.BoardNo=BoardNo OR  BoardNo =0 ) AND BC.Enabled = TRUE
--	GROUP BY BC.ContentNo
--	),
PERMISSION_BOARD AS (SELECT B.BoardNo, B.Name,B.ViewMode,B.SpecType
	FROM Board_Boards B 
	LEFT JOIN PERMISSION P ON P.ItemNo=B.BoardNo 
	LEFT JOIN DEPARTPERMISSION D ON D.ItemNo=B.BoardNo 
	WHERE (B.BoardNo=board_getlistboardcontent_bk.boardno OR  BoardNo =0 ) AND ( IsAdmin = TRUE   OR P.AllowValue >0 OR  D.AllowValue >0 OR B.SpecType=1
	) 
	),
VIEWED AS (SELECT DISTINCT UserNo,ContentNo
FROM Board_ViewedLogs 
WHERE UserNo=board_getlistboardcontent_bk.userno),
VIEWEDLIST AS (
	SELECT DISTINCT BV.ContentNo, COUNT(BV.UserNo) AS ViewedCount
	FROM (SELECT DISTINCT ContentNo,UserNo FROM Board_ViewedLogs)  BV 
	INNER JOIN Board_Contents BC ON BV.ContentNo=BC.ContentNo 
	INNER JOIN Board_Boards BB ON BB.BoardNo=BC.BoardNo
	LEFT JOIN SHARE S ON S.ContentNo=BV.ContentNo AND S.Rn=1
	WHERE  BB.SpecType=1 OR  BC.IsShareAll=TRUE OR COALESCE(S.ContentNo,0)!=0 OR BV.UserNo=BC.RegUserNo 
	GROUP BY BV.ContentNo
),
TMP AS (
	SELECT BC.BoardNo,BC.ContentNo,BC.Title,BC.IsFile,BC.ViewedCount,BC.RootId,BC.TitleEffect,BC.RegDate,BC.ModDate,--T.Url AS FileUrl,
	CASE WHEN STRPOS(B.Name, '{')>0 THEN (SELECT StringValue FROM ParseJson(B.Name)  WHERE NAME=board_getlistboardcontent_bk.langcode) ELSE B.Name END AS BoardName ,
	CASE LangCode WHEN 'EN' THEN  COALESCE(OU.Name_EN,OU.Name) WHEN 'VN' THEN  COALESCE(OU.Name_VN,OU.Name) WHEN 'CH' THEN COALESCE(OU.Name_CH,OU.Name)  WHEN 'JP' THEN COALESCE(OU.Name_JP,OU.Name) ELSE OU.Name END AS RegUserName,
	CASE LangCode WHEN 'EN' THEN  COALESCE(OP.Name_EN,OP.Name) WHEN 'VN' THEN  COALESCE(OP.Name_VN,OP.Name) WHEN 'CH' THEN COALESCE(OP.Name_CH,OP.Name)  WHEN 'JP' THEN COALESCE(OP.Name_JP,OP.Name) ELSE OP.Name END AS RegPositionName,
	CASE LangCode WHEN 'EN' THEN  COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN  COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name)  WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END AS RegDepartName,
	SUBSTRING(TO_CHAR(BC.RegDate, 'YYYY-MM-DD HH24:MI:SS'),3,14) as RegDateToString,
	CASE WHEN '2020-12-31'::timestamp> BC.RegDate OR(BV.ContentNo IS NOT NULL OR BC.RegUserNo=board_getlistboardcontent_bk.userno)  THEN TRUE ELSE FALSE END AS IsReaded ,
	ROW_NUMBER() OVER(PARTITION BY BC.Enabled  ORDER BY 
		CASE WHEN SortType=0 AND SortColumn='' THEN BC.RootId END DESC,
		CASE WHEN SortType=0 AND SortColumn='' THEN BC.HeadNo END ASC,
		CASE WHEN SortType=0 AND SortColumn='' THEN  BC.ContentNo END ASC,
		CASE WHEN SortType=0 AND SortColumn='LISTSORT' THEN BC.IsNotice END DESC,
		CASE WHEN SortType=0 AND SortColumn='LISTSORT' THEN  BC.RootId END DESC,
		CASE WHEN SortType=0 AND SortColumn='LISTSORT' THEN BC.HeadNo END ASC,
		CASE WHEN SortType=0 AND SortColumn='LISTSORT' THEN  BC.ContentNo END ASC,
		CASE WHEN SortType=0 AND SortColumn='TITLE' THEN  BC.Title END ASC,
		CASE WHEN SortType=0 AND SortColumn='BOARD' THEN  CASE WHEN STRPOS(B.Name, '{')>0 THEN (SELECT StringValue FROM ParseJson(B.Name)  WHERE NAME=board_getlistboardcontent_bk.langcode) ELSE B.Name END END ASC,
		CASE WHEN SortType=0 AND SortColumn='REGUSER' THEN  CASE LangCode WHEN 'EN' THEN  COALESCE(OU.Name_EN,OU.Name) WHEN 'VN' THEN  COALESCE(OU.Name_VN,OU.Name) WHEN 'CH' THEN COALESCE(OU.Name_CH,OU.Name)  WHEN 'JP' THEN COALESCE(OU.Name_JP,OU.Name) ELSE OU.Name END END ASC,
		CASE WHEN SortType=0 AND SortColumn='DEPART' THEN  CASE LangCode WHEN 'EN' THEN  COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN  COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name)  WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END END ASC,
		CASE WHEN SortType=0 AND SortColumn='REGDATE' THEN BC.RegDate END ASC,
		CASE WHEN SortType=0 AND SortColumn='VIEWED' THEN  BC.ViewedCount END ASC,
		CASE WHEN SortType=0 AND SortColumn='TYPE' THEN  BC.Type END ASC,
		CASE WHEN SortType=0 AND SortColumn='ERRORTYPE' THEN  BC.ErrorType END ASC,
		CASE WHEN SortType=0 AND SortColumn='PERSONTYPE' THEN  BC.PersonType END ASC,
		CASE WHEN SortType=1 AND SortColumn='TITLE' THEN  BC.Title END DESC,
		CASE WHEN SortType=1 AND SortColumn='BOARD' THEN  CASE WHEN STRPOS(B.Name, '{')>0 THEN (SELECT StringValue FROM ParseJson(B.Name)  WHERE NAME=board_getlistboardcontent_bk.langcode) ELSE B.Name END END DESC,
		CASE WHEN SortType=1 AND SortColumn='REGUSER' THEN   CASE LangCode WHEN 'EN' THEN  COALESCE(OU.Name_EN,OU.Name) WHEN 'VN' THEN  COALESCE(OU.Name_VN,OU.Name) WHEN 'CH' THEN COALESCE(OU.Name_CH,OU.Name)  WHEN 'JP' THEN COALESCE(OU.Name_JP,OU.Name) ELSE OU.Name END END DESC,
		CASE WHEN SortType=1 AND SortColumn='DEPART' THEN  CASE LangCode WHEN 'EN' THEN  COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN  COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name)  WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END END DESC,
		CASE WHEN SortType=1 AND SortColumn='REGDATE' THEN  BC.RegDate END DESC,
		CASE WHEN SortType=1 AND SortColumn='VIEWED' THEN  BC.ViewedCount END DESC,
		CASE WHEN SortType=1 AND SortColumn='TYPE' THEN  BC.Type END DESC,
		CASE WHEN SortType=1 AND SortColumn='ERRORTYPE' THEN  BC.ErrorType END DESC,
		CASE WHEN SortType=1 AND SortColumn='PERSONTYPE' THEN  BC.PersonType END DESC
		) AS RowNumber,
	B.ViewMode AS BoardType,
	B.SpecType,
	CASE WHEN IsAdmin = TRUE OR P.AllowValue%2<>0 OR D.AllowValue%2<>0 OR BC.RegUserNo=board_getlistboardcontent_bk.userno THEN TRUE ELSE FALSE END AS IsDelete ,
	BC.Type,
	BC.ErrorType,
	BC.PersonType,
	BC.VisitDate,
	BC.VisitCompleteDate,
	BC.ConstructionName,
	BC.ApplyTo,
	BC.MailRecipientNo,
	BC.MailRecipientName,
	CASE WHEN BC.DateView IS NULL THEN NULL ELSE (BC.DateView::date - BC.RegDate::date)  END AS DayDateView,
	BC.Important,
	BC.DesignNo,
	BC.RegUserNo,
	BC.Private,
	BC.IsNotice,
	BC.Purpose,
	BC.RecommendedCount,
	BC.IsRecommendPublic
	FROM BOARD_CONTENTS BC
	--LEFT JOIN (SELECT ContentNo,Url,ROW_NUMBER() OVER(PARTITION BY ContentNo  ORDER BY ContentNo ASC) AS Rn FROM Board_Files ) T ON T.ContentNo=BC.ContentNo AND Rn=1
	INNER JOIN PERMISSION_BOARD B ON B.BoardNo=BC.BoardNo
	LEFT JOIN Organization_Users OU ON OU.UserNo = BC.RegUserNo
	LEFT JOIN Organization_Positions OP ON OP.PositionNo = BC.RegPositionNo
	LEFT JOIN Organization_Departments OD ON OD.DepartNo = BC.RegDepartNO
	LEFT JOIN VIEWED BV ON BV.ContentNo=BC.ContentNo
	LEFT JOIN PERMISSION P ON P.ItemNo=BC.BoardNo 
	LEFT JOIN DEPARTPERMISSION D ON D.ItemNo=BC.BoardNo 
	LEFT JOIN SHARE S ON S.ContentNo=BC.ContentNo AND S.Rn=1
	WHERE (BC.BoardNo=board_getlistboardcontent_bk.boardno OR   (BoardNo =0 AND B.ViewMode>=2)) 
 
	AND BC.Enabled = TRUE 
	AND BC.RegDate>=board_getlistboardcontent_bk.fromdate 
	AND BC.RegDate<=board_getlistboardcontent_bk.todate 
	AND (FilterType=100 OR (FilterType=1 AND BV.ContentNo IS NULL))
	AND (TitleEffect=1 OR (TitleEffect=0 AND TitleEffect=0))
	AND (COALESCE(MgDepartment,'')='' OR MgDepartment=BC.PersonType)
	AND (COALESCE(SearchValue,'')=''  
			OR(SearchType=0 AND  BC.Title ILIKE '%' || SearchValue || '%')
			OR(SearchType=1 AND CASE LangCode WHEN 'EN' THEN  COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN  COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name)  WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END ILIKE '%' || SearchValue || '%')
			OR(SearchType=2 AND CASE LangCode WHEN 'EN' THEN  COALESCE(OU.Name_EN,OU.Name) WHEN 'VN' THEN  COALESCE(OU.Name_VN,OU.Name) WHEN 'CH' THEN COALESCE(OU.Name_CH,OU.Name)  WHEN 'JP' THEN COALESCE(OU.Name_JP,OU.Name) ELSE OU.Name END ILIKE '%' || SearchValue || '%')
			OR(SearchType=3 AND BC.Type= board_getlistboardcontent_bk.searchvalue)
			OR(SearchType=4 AND BC.Type ILIKE '%' || SearchValue || '%')
			OR(SearchType=5 AND BC.ErrorType ILIKE '%' || SearchValue || '%')
			OR(SearchType=6 AND BC.ApplyTo ILIKE '%' || SearchValue || '%')
			OR(SearchType=7 AND BC.ConstructionName ILIKE '%' || SearchValue || '%')
			)
		-- CASE SearchType 
		--	WHEN 0 THEN BC.Title 
		--	WHEN 1 THEN CASE LangCode WHEN 'EN' THEN  COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN  COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name)  WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END 
		--	WHEN 2 THEN CASE LangCode WHEN 'EN' THEN  COALESCE(OU.Name_EN,OU.Name) WHEN 'VN' THEN  COALESCE(OU.Name_VN,OU.Name) WHEN 'CH' THEN COALESCE(OU.Name_CH,OU.Name)  WHEN 'JP' THEN COALESCE(OU.Name_JP,OU.Name) ELSE OU.Name END 
		--	WHEN 3 THEN BC.Type  
		--	ELSE CASE LangCode WHEN 'EN' THEN  COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN  COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name)  WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END  
		--END ILIKE '%' || SearchValue || '%')
	AND ( IsAdmin = TRUE OR BC.RegUserNo=board_getlistboardcontent_bk.userno  OR P.AllowValue=7 OR  D.AllowValue=7 OR ((P.AllowAccessNo IS NOT NULL OR D.AllowAccessNo IS NOT NULL)AND B.SpecType=0 AND (BC.IsShareAll = TRUE  OR S.ContentNo IS NOT NULL)) OR ((BC.IsShareAll = TRUE  OR S.ContentNo IS NOT NULL) AND  B.SpecType=1)
)
) ,
Total AS (Select MAX(RowNumber) as ToTal FROM TMP)
SELECT T.BoardNo,
T.ContentNo ,
T.Title,
COALESCE(F.Url,'') AS FileUrl,
F.Name AS FileName,
REPLACE(REPLACE(COALESCE(F.Url,''), '/Attach/', '/Thumbnail/'),'/File/','/Thumbnail/') AS ThumbnailFileUrl,
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
T.ModDate,
T.Type,
	T.ErrorType,
	T.PersonType,
	T.VisitDate,
	T.VisitCompleteDate,
	T.ConstructionName,
	T.DayDateView,
	T.ApplyTo,
	T.MailRecipientNo,
	T.MailRecipientName,
	T.Important,
	T.DesignNo,
	T.Private,
	T.RegUserNo,
	T.IsNotice,
	T.Purpose,
	T.RecommendedCount,
	T.IsRecommendPublic,
	c.Total -T.RowNumber +1 AS RowNumber
FROM TMP T  
LEFT JOIN Total c ON c.Total>0
LEFT JOIN (SELECT BR.ContentNo,COUNT(BR.ReplyNo) AS ReplyCount FROM Board_Replies BR GROUP BY BR.ContentNo)R ON R.ContentNo=T.ContentNo
LEFT JOIN (SELECT ContentNo,Url,Name,ROW_NUMBER() OVER(PARTITION BY ContentNo  ORDER BY ContentNo ASC) AS Rn FROM Board_Files ) F ON F.ContentNo=T.ContentNo AND F.Rn=1
LEFT JOIN VIEWEDLIST VL ON VL.ContentNo=T.ContentNo
--INNER JOIN REP R ON R.ContentNo=T.ContentNo
WHERE   T.RowNumber>(CurentPage-1)*PageSize AND T.RowNumber<=board_getlistboardcontent_bk.curentpage*PageSize
ORDER BY T.RowNumber;
END IF;
END;

--LEFT JOIN (SELECT BR.ContentNo,COUNT(BR.ReplyNo) AS ReplyCount FROM Board_Replies BR GROUP BY BR.ContentNo)R  ON R.ContentNo=T.ContentNo
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.