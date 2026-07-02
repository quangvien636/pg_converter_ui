-- ─── PROCEDURE→FUNCTION: board_getallboardcontents ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: DATEADD was not fully converted; use interval arithmetic
DROP FUNCTION IF EXISTS public.board_getallboardcontents(integer, integer, boolean, integer, integer, character varying, integer, integer, timestamp without time zone, timestamp without time zone, integer, boolean, boolean, integer, character varying);
CREATE OR REPLACE FUNCTION public.board_getallboardcontents(
    IN userno integer DEFAULT 70,
    IN sortcolumn integer DEFAULT 1,
    IN isascending boolean DEFAULT FALSE,
    IN countperpage integer DEFAULT 10,
    IN currentpageindex integer DEFAULT 1,
    IN languagesign character varying DEFAULT 'KO',
    IN filtertype integer DEFAULT 100,
    IN viewmode integer DEFAULT -1,
    IN fromdate timestamp without time zone DEFAULT '2000-01-01 00:00:00',
    IN todate timestamp without time zone DEFAULT '2028-11-29 11:09:58.860',
    IN typeeff integer DEFAULT 1,
    IN isalarm boolean DEFAULT FALSE,
    IN isadmin boolean DEFAULT TRUE,
    IN searchtype integer DEFAULT 0,
    IN searchvalue character varying DEFAULT ''
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

RETURN QUERY
WITH PERMISSION AS (
	Select *
	FROM Board_AllowAccess
	WHERE ItemType=2 AND UserNo=board_getallboardcontents.userno
),
DEPARTPERMISSION AS (
	Select ItemNo ,AllowValue,AllowAccessNo
	FROM Board_DepartAllowAccess BD
	INNER JOIN Organization_BelongToDepartment OB ON OB.DepartNo=BD.DepartNo
	WHERE BD.ItemType=2 AND OB.UserNo=board_getallboardcontents.userno AND OB.IsDefault= TRUE
),
SHARE AS(
	SELECT U.UserNo ,BS.ContentNo ,ROW_NUMBER() OVER(PARTITION BY BS.ContentNo  ORDER BY BS.ContentNo ASC) AS Rn
	FROM Board_Sharers BS
	INNER JOIN (
		SELECT U.UserNo,OP.DepartNo
		FROM Organization_Users U
		INNER JOIN Organization_BelongToDepartment OP ON OP.UserNo=U.UserNo
		WHERE U.UserNo=board_getallboardcontents.userno --AND U.Enabled = TRUE
		) U ON U.UserNo=BS.UserNo OR U.DepartNo=BS.DepartNo
),
REP AS (SELECT BC.ContentNo,Count(BR.ReplyNo) AS ReplyCount
	FROM Board_Contents BC
	LEFT JOIN Board_Replies BR ON BR.ContentNo=BC.ContentNo
	WHERE BC.Enabled = TRUE
	GROUP BY BC.ContentNo
	),
VIEWED AS (SELECT DISTINCT UserNo,ContentNo
FROM Board_ViewedLogs
WHERE UserNo=board_getallboardcontents.userno),
TMP AS (
	SELECT BC.*,T.Url AS FileUrl,
	CASE WHEN STRPOS(B.Name, '{')>0 THEN (SELECT StringValue FROM ParseJson(B.Name)  WHERE NAME=board_getallboardcontents.languagesign) ELSE B.Name END AS BoardName ,
	CASE LanguageSign WHEN 'EN' THEN  COALESCE(OU.Name_EN,OU.Name) WHEN 'VN' THEN  COALESCE(OU.Name_VN,OU.Name) WHEN 'CH' THEN COALESCE(OU.Name_CH,OU.Name)  WHEN 'JP' THEN COALESCE(OU.Name_JP,OU.Name) ELSE OU.Name END AS RegUserName,
	CASE LanguageSign WHEN 'EN' THEN  COALESCE(OP.Name_EN,OP.Name) WHEN 'VN' THEN  COALESCE(OP.Name_VN,OP.Name) WHEN 'CH' THEN COALESCE(OP.Name_CH,OP.Name)  WHEN 'JP' THEN COALESCE(OP.Name_JP,OP.Name) ELSE OP.Name END AS RegPositionName,
	CASE LanguageSign WHEN 'EN' THEN  COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN  COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name)  WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END AS RegDepartName,
	TO_CHAR(BC.RegDate, 'YYYY-MM-DD HH24:MI:SS') as RegDateToString,
	CASE WHEN BV.ContentNo IS NOT NULL THEN TRUE ELSE FALSE END AS IsReaded ,
	ROW_NUMBER() OVER(PARTITION BY BC.Enabled  ORDER BY BC.RegDate DESC) AS RowNumber,
	B.ViewMode AS BoardType,
	CASE WHEN IsAdmin = TRUE OR P.AllowValue%2<>0 OR D.AllowValue%2<>0 OR BC.RegUserNo=board_getallboardcontents.userno THEN TRUE ELSE FALSE END AS IsDelete
	FROM BOARD_CONTENTS BC
	LEFT JOIN (SELECT *,ROW_NUMBER() OVER(PARTITION BY ContentNo  ORDER BY ContentNo ASC) AS Rn FROM Board_Files ) T ON T.ContentNo=BC.ContentNo AND Rn=1
	LEFT JOIN Board_Boards B ON B.BoardNo=BC.BoardNo
	LEFT JOIN Organization_Users OU ON OU.UserNo = BC.RegUserNo
	LEFT JOIN Organization_Positions OP ON OP.PositionNo = BC.RegPositionNo
	LEFT JOIN Organization_Departments OD ON OD.DepartNo = BC.RegDepartNO
	LEFT JOIN VIEWED BV ON BV.ContentNo=BC.ContentNo
	LEFT JOIN PERMISSION P ON P.ItemNo=BC.BoardNo
	LEFT JOIN DEPARTPERMISSION D ON D.ItemNo=BC.BoardNo
	LEFT JOIN SHARE S ON S.ContentNo=BC.ContentNo  AND S.Rn=1
	WHERE
	--(BC.BoardNo=BoardNo OR   (BoardNo =0 AND B.ViewMode=2)) AND
	BC.Enabled = TRUE AND BC.RegDate>=board_getallboardcontents.fromdate AND BC.RegDate<=board_getallboardcontents.todate
	AND (FilterType=100 OR (FilterType=1 AND BV.ContentNo IS NULL))
	AND  TitleEffect=board_getallboardcontents.typeeff
	AND  (IsAlarm = FALSE OR (BC.IsAlarm = board_getallboardcontents.isalarm AND IsAlarm = TRUE  AND COALESCE(BC.StartDate,NOW())<= NOW() AND COALESCE(BC.EndDate,DATEADD(month, 1, NOW()))>= NOW()  ))
	AND ( IsAdmin = TRUE OR BC.RegUserNo=board_getallboardcontents.userno OR  ((P.AllowAccessNo IS NOT NULL OR D.AllowAccessNo IS NOT NULL)  AND B.SpecType=0) OR D.AllowAccessNo IS NOT NULL OR((BC.IsShareAll = TRUE  OR S.ContentNo IS NOT NULL) AND  B.SpecType=1))
	AND (COALESCE(SearchValue,'')='' OR
		 CASE SearchType
			WHEN 1 THEN BC.Title
			WHEN 2 THEN OD.Name
			WHEN 3 THEN OU.Name
			ELSE BC.Title
		END ILIKE '%' || SearchValue || '%')


) ,

Total AS (Select count(*) as ToTal FROM TMP)
SELECT T.BoardNo,
T.ContentNo ,
T.Title,
T.FileUrl,
T.IsFile,
T.BoardName ,
T.RegUserName,
T.RegPositionName,
T.RegDepartName,
T.ViewedCount ,
T.RegDateToString,
T.RootId,
T.TitleEffect,
T.IsDelete ,
T.IsReaded,
c.Total,
R.ReplyCount,
T.BoardType,
T.RegDate
FROM TMP T
LEFT JOIN Total c ON c.Total>0
--LEFT JOIN PERMISSION P ON P.ItemNo=T.ContentNo


INNER JOIN REP R ON R.ContentNo=T.ContentNo
WHERE --(T.IsShareAll = TRUE OR IsAdmin = TRUE OR P.AllowAccessNo IS NOT NULL OR S.ContentNo IS NOT NULL )  AND
T.RowNumber>(CurrentPageIndex-1)*CountPerPage AND T.RowNumber<=board_getallboardcontents.currentpageindex*CountPerPage
ORDER BY T.RootId DESC,T.ContentNo ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role dazone not verified.