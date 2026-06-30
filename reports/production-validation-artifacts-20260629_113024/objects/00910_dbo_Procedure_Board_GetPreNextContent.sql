-- ─── PROCEDURE→FUNCTION: board_getprenextcontent ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.board_getprenextcontent(integer, integer, character varying, integer, boolean);
CREATE OR REPLACE FUNCTION public.board_getprenextcontent(
    IN contentno integer DEFAULT 4946,
    IN boardno integer DEFAULT 0,
    IN languagesign character varying DEFAULT 'EN',
    IN userno integer DEFAULT 70,
    IN isadmin boolean DEFAULT TRUE
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	WITH PERMISSION AS (
	Select * 
	FROM Board_AllowAccess 
	WHERE ItemType=2 AND UserNo=board_getprenextcontent.userno
),DEPARTPERMISSION AS (
	Select ItemNo ,AllowValue,AllowAccessNo 
	FROM Board_DepartAllowAccess BD 
	INNER JOIN Organization_BelongToDepartment OB ON OB.DepartNo=BD.DepartNo
	WHERE BD.ItemType=2 AND OB.UserNo=board_getprenextcontent.userno AND OB.IsDefault= TRUE
),
SHARE AS(
	SELECT U.UserNo ,BS.ContentNo
	FROM Board_Sharers BS
	INNER JOIN (
		SELECT U.UserNo,OP.DepartNo 
		FROM Organization_Users U 
		INNER JOIN Organization_BelongToDepartment OP ON OP.UserNo=U.UserNo
		WHERE U.UserNo=board_getprenextcontent.userno --AND U.Enabled = TRUE
		) U ON U.UserNo=BS.UserNo OR U.DepartNo=BS.DepartNo
),
REP AS (SELECT BC.ContentNo,Count(BR.ReplyNo) AS ReplyCount
	FROM Board_Contents BC
	LEFT JOIN Board_Replies BR ON BR.ContentNo=BC.ContentNo
	WHERE (BC.BoardNo=board_getprenextcontent.boardno OR  BoardNo =0 ) AND BC.Enabled = TRUE
	GROUP BY BC.ContentNo
	)
,TMP AS (
	SELECT --BC.*,--T.Url AS FileUrl,
	BC.ContentNo,BC.Title,BC.ModUserName,BC.Private,BC.IsShareAll,
	CASE WHEN STRPOS(B.Name, '{')>0 THEN (SELECT /* /* TOP 1 */ */ StringValue FROM ParseJson(B.Name)  WHERE NAME=board_getprenextcontent.languagesign) ELSE B.Name END AS BoardName ,
	CASE LanguageSign WHEN 'EN' THEN  COALESCE(OU.Name_EN,OU.Name) WHEN 'VN' THEN  COALESCE(OU.Name_VN,OU.Name) WHEN 'CH' THEN COALESCE(OU.Name_CH,OU.Name)  WHEN 'JP' THEN COALESCE(OU.Name_JP,OU.Name) ELSE OU.Name END AS RegUserName,
	CASE LanguageSign WHEN 'EN' THEN  COALESCE(OP.Name_EN,OP.Name) WHEN 'VN' THEN  COALESCE(OP.Name_VN,OP.Name) WHEN 'CH' THEN COALESCE(OP.Name_CH,OP.Name)  WHEN 'JP' THEN COALESCE(OP.Name_JP,OP.Name) ELSE OP.Name END AS RegPositionName,
	CASE LanguageSign WHEN 'EN' THEN  COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN  COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name)  WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END AS RegDepartName,
	CONVERT(text, BC.RegDate, 120) as RegDateToString,
	B.ViewMode,
	ROW_NUMBER() OVER(PARTITION BY BC.Enabled  ORDER BY BC.RootId DESC ,BC.ContentNo ASC) AS RowNumber
	FROM BOARD_CONTENTS BC
	LEFT JOIN Board_Boards B ON B.BoardNo=BC.BoardNo
	LEFT JOIN PERMISSION P ON P.ItemNo=BC.BoardNo
	LEFT JOIN DEPARTPERMISSION D ON D.ItemNo=BC.BoardNo
	LEFT JOIN SHARE S ON S.ContentNo=BC.ContentNo
	LEFT JOIN Organization_Users OU ON OU.UserNo = BC.RegUserNo
	LEFT JOIN Organization_Positions OP ON OP.PositionNo = BC.RegPositionNo
	LEFT JOIN Organization_Departments OD ON OD.DepartNo = BC.RegDepartNO
	WHERE (BC.BoardNo=board_getprenextcontent.boardno OR   (BoardNo =0 AND B.ViewMode>=2)) AND BC.Enabled = TRUE 
	AND ( IsAdmin = TRUE OR BC.RegUserNo=board_getprenextcontent.userno  OR P.AllowValue=7 OR  D.AllowValue=7 OR ((P.AllowAccessNo IS NOT NULL OR D.AllowAccessNo IS NOT NULL)AND B.SpecType=0 AND (BC.IsShareAll = TRUE  OR S.ContentNo IS NOT NULL)) OR ((BC.IsShareAll = TRUE  OR S.ContentNo IS NOT NULL) AND  B.SpecType=1))


) ,
Total AS (Select count(*) as ToTal FROM TMP)


RETURN QUERY
SELECT T.ContentNo,T.Title,T.ModUserName,T.BoardName,T.RegDateToString,FALSE AS Type,T.Private,T.ViewMode
FROM TMP T 
LEFT JOIN PERMISSION P ON P.ItemNo=T.ContentNo
LEFT JOIN SHARE S ON S.ContentNo=T.ContentNo
WHERE (T.IsShareAll = TRUE OR IsAdmin = TRUE OR P.AllowAccessNo IS NOT NULL OR S.ContentNo IS NOT NULL ) AND
T.RowNumber=(SELECT RowNumber-1 FROM TMP WHERE ContentNo=board_getprenextcontent.contentno)
UNION
RETURN QUERY
SELECT T.ContentNo,T.Title,T.ModUserName,T.BoardName,T.RegDateToString,TRUE AS Type,T.Private,T.ViewMode
FROM TMP T 
LEFT JOIN PERMISSION P ON P.ItemNo=T.ContentNo
LEFT JOIN SHARE S ON S.ContentNo=T.ContentNo
WHERE (T.IsShareAll = TRUE OR IsAdmin = TRUE OR P.AllowAccessNo IS NOT NULL OR S.ContentNo IS NOT NULL ) AND
T.RowNumber=(SELECT RowNumber+1 FROM TMP WHERE ContentNo=board_getprenextcontent.contentno);

	----SET IsAdmin = TRUE
	--,
	--ContentNo bigint,
	--BoardNo int,
	--BoardName nvarchar(200),
	--ModUserNo int,
	--ModUserName nvarchar(200),
	--ModPositionNo int,
	--ModPositionName nvarchar(200),
	--ModDepartNo int,
	--ModDepartName nvarchar(200),
	--RegDate datetime,
	--RegUserNo int,
	--Title nvarchar(500),
	--TitleEffect int,
	--GroupNo bigint,
	--Depth int,
	--OrderNo int,
	--HeadNo int,
	--IsNotice bit,
	--IsFile bit,
	--FileCount int,
	--ReplyCount int,
	--RecommendedCount int,
	--ViewedCount int,
	--HeadName nvarchar(200),
	--IsRecommended bit,
	--IsAlarm bit,
	--ReadCount int
	--)

	----not admin :
	--if(IsAdmin = FALSE) begin
	---- Nghiem add 20180924
	--insert into tempTable
	--SELECT /* TOP 1 */ '0' as Type, BC.ContentNo,BC.BoardNo,(select Name from Board_Boards where BoardNo= BC.BoardNo) as BoardName, BC.ModUserNo, 
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end) as ModUserName,
	--	BC.ModPositionNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,
	--	 BC.ModDepartNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName,
	--	BC.RegDate,
	--	BC.RegUserNo,
	--	  BC.Title, BC.TitleEffect, BC.GroupNo, BC.Depth, BC.OrderNo, BC.HeadNo, BC.IsNotice,		
	--	   BC.IsFile, BC.FileCount,
	--	BC.ReplyCount, 
	--	BC.RecommendedCount,
	--	 BC.ViewedCount,
		
	--	COALESCE(BH.Name, '') AS HeadName, FALSE AS IsRecommended
	--	,BC.IsAlarm
	--	,(Select Count(*) From Board_ViewedLogs where Board_ViewedLogs.UserNo=UserNo AND BC.ContentNo=Board_ViewedLogs.ContentNo) As ReadCount 
	--FROM Board_Contents BC
	--LEFT JOIN Board_Heads BH ON BH.HeadNo = BC.HeadNo	
	--LEFT JOIN (SELECT * FROM public."Board_GetBoardAllow"(UserNo ,2)) AC ON BC.BoardNo=AC.BoardNo
	--LEFT JOIN  (SELECT * FROM public."Board_GetBoardAllow"(UserNo,4)) AD ON BC.BoardNo=AD.BoardNo
	--LEFT JOIN  (SELECT * FROM public."Board_GetBoardAllow"(UserNo,1)) AE ON BC.BoardNo=AE.BoardNo
	----(AE.BoardNo IS NOT NULL OR AC.BoardNo IS NOT NULL OR (AD.BoardNo IS NOT NULL AND BC.RegUserNo = UserNo)))
	--WHERE BC.ContentNo < ContentNo and BC.BoardNo = BoardNo 
	--AND BC.Enabled = TRUE 
	--AND (BC.RegUserNo = UserNo	OR (BC.ContentNo IN (SELECT BS1.ContentNo FROM Board_Sharers BS1 inner JOIN public."Organization_GetDepartmentsByUser" (UserNo) DP ON DP.DepartNo= BS1.DepartNo)) 
	--	OR (BC.ContentNo IN ( SELECT BSS1.ContentNo FROM Board_Sharers BSS1 where BSS1.contentno=BC.ContentNo and BSS1.userno=UserNo)) 
	--	OR ((SELECT COUNT(*) FROM Board_Sharers BS2 WHERE BS2.CONTENTNO = BC.ContentNO) <=0 ))
	--order by BC.ContentNo desc


	--insert into tempTable
	--SELECT /* TOP 1 */ '1'as Type, BC.ContentNo, BC.BoardNo,(select Name from Board_Boards where BoardNo= BC.BoardNo) as BoardName, BC.ModUserNo, 
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end) as ModUserName,
	--	BC.ModPositionNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,
	--	 BC.ModDepartNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName,
	--	BC.RegDate,
	--	BC.RegUserNo,	
	--	  BC.Title, BC.TitleEffect, BC.GroupNo, BC.Depth, BC.OrderNo, BC.HeadNo, BC.IsNotice,		 
	--	   BC.IsFile, BC.FileCount,
	--	BC.ReplyCount, 
	--	BC.RecommendedCount,
	--	 BC.ViewedCount,	
	--	COALESCE(BH.Name, '') AS HeadName, FALSE AS IsRecommended
	--	,BC.IsAlarm
	--	,(Select Count(*) From Board_ViewedLogs where Board_ViewedLogs.UserNo=UserNo AND BC.ContentNo=Board_ViewedLogs.ContentNo) As ReadCount 
	--FROM Board_Contents BC
	--LEFT JOIN Board_Heads BH ON BH.HeadNo = BC.HeadNo	
	--LEFT JOIN (SELECT * FROM public."Board_GetBoardAllow"(UserNo ,2)) AC ON BC.BoardNo=AC.BoardNo
	--LEFT JOIN  (SELECT * FROM public."Board_GetBoardAllow"(UserNo,4)) AD ON BC.BoardNo=AD.BoardNo
	--LEFT JOIN  (SELECT * FROM public."Board_GetBoardAllow"(UserNo,1)) AE ON BC.BoardNo=AE.BoardNo

	--WHERE BC.ContentNo > ContentNo and BC.BoardNo = BoardNo
	--AND BC.Enabled = TRUE 	
	--AND (BC.RegUserNo = UserNo	OR (BC.ContentNo IN (SELECT BS1.ContentNo FROM Board_Sharers BS1 inner JOIN public."Organization_GetDepartmentsByUser" (UserNo) DP ON DP.DepartNo= BS1.DepartNo)) 
	--	OR (BC.ContentNo IN ( SELECT BSS1.ContentNo FROM Board_Sharers BSS1 where BSS1.contentno=BC.ContentNo and BSS1.userno=UserNo)) 
	--	OR ((SELECT COUNT(*) FROM Board_Sharers BS2 WHERE BS2.CONTENTNO = BC.ContentNO) <=0 ))
	--order by BC.ContentNo asc
	--end
	---- Is admin
	--else begin


	--insert into tempTable
	--SELECT /* TOP 1 */ '0' as Type, BC.ContentNo,BC.BoardNo,(select Name from Board_Boards where BoardNo= BC.BoardNo) as BoardName, BC.ModUserNo, 
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end) as ModUserName,
	--	BC.ModPositionNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,
	--	 BC.ModDepartNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName,
	--	BC.RegDate,
	--	BC.RegUserNo,
	--	  BC.Title, BC.TitleEffect, BC.GroupNo, BC.Depth, BC.OrderNo, BC.HeadNo, BC.IsNotice,
	--	  -- BC.Content,
	--	   BC.IsFile, BC.FileCount,
	--	BC.ReplyCount, 
	--	BC.RecommendedCount,
	--	 BC.ViewedCount,
	--	 --, BC.StartDate, BC.EndDate,
		
	--	COALESCE(BH.Name, '') AS HeadName, FALSE AS IsRecommended

	--	--,BC.RegUserNo, 
	--	--( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
	--	--BC.RegPositionNo,
	--	--( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
	--	-- BC.RegDepartNo,
	--	--( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
	--	,BC.IsAlarm
	--	,(Select Count(*) From Board_ViewedLogs where Board_ViewedLogs.UserNo=UserNo AND BC.ContentNo=Board_ViewedLogs.ContentNo) As ReadCount 
	--FROM Board_Contents BC
	--LEFT JOIN Board_Heads BH ON BH.HeadNo = BC.HeadNo	
	--WHERE BC.ContentNo < ContentNo and BC.BoardNo = BoardNo	
	--AND BC.Enabled = TRUE 
	--order by BC.ContentNo desc


	--insert into tempTable
	--SELECT /* TOP 1 */ '1' as Type, BC.ContentNo, BC.BoardNo,(select Name from Board_Boards where BoardNo= BC.BoardNo) as BoardName, BC.ModUserNo, 
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end) as ModUserName,
	--	BC.ModPositionNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,
	--	 BC.ModDepartNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName,
	--	BC.RegDate,
	--	BC.RegUserNo,
	--	-- BC.ModDate,
	--	  BC.Title, BC.TitleEffect, BC.GroupNo, BC.Depth, BC.OrderNo, BC.HeadNo, BC.IsNotice,
	--	  -- BC.Content,
	--	   BC.IsFile, BC.FileCount,
	--	BC.ReplyCount, 
	--	BC.RecommendedCount,
	--	 BC.ViewedCount,
	--	 --, BC.StartDate, BC.EndDate,
		
	--	COALESCE(BH.Name, '') AS HeadName, FALSE AS IsRecommended

	--	--,BC.RegUserNo, 
	--	--( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
	--	--BC.RegPositionNo,
	--	--( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
	--	-- BC.RegDepartNo,
	--	--( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
	--	,BC.IsAlarm
	--	,(Select Count(*) From Board_ViewedLogs where Board_ViewedLogs.UserNo=UserNo AND BC.ContentNo=Board_ViewedLogs.ContentNo) As ReadCount 
	--FROM Board_Contents BC
	--LEFT JOIN Board_Heads BH ON BH.HeadNo = BC.HeadNo	
	--WHERE BC.ContentNo > ContentNo and BC.BoardNo = BoardNo
	--AND BC.Enabled = TRUE 
	--order by BC.ContentNo asc

	--end
	--select * from tempTable
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
