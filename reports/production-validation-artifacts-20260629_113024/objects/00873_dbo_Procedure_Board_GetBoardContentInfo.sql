-- ─── PROCEDURE→FUNCTION: board_getboardcontentinfo ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.board_getboardcontentinfo(bigint, character varying);
CREATE OR REPLACE FUNCTION public.board_getboardcontentinfo(
    IN contentno bigint DEFAULT 4780,
    IN languagesign character varying DEFAULT 'EN'
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

--DECLARE ShareDepart AS text;
--DECLARE ShareUser AS text;
--SET ShareDepart= STUFF((SELECT ';' || DepartName
--               FROM Board_Sharers 
--              WHERE ContentNo=ContentNo AND (UserNo IS NULL OR UserNo=0)
--		   FOR XML PATH(''), TYPE).value('.','text'), 1, 1, '');
--SET ShareUser =  STUFF((SELECT ';' || OU.Name
--               FROM Board_Sharers  BS
--			   LEFT JOIN ORGANIZATION_USERS OU ON OU.UserNo=BS.UserNo
--              WHERE ContentNo=ContentNo AND BS.UserNo IS NOT NULL AND BS.UserNo<>0
--		   FOR XML PATH(''), TYPE).value('.','text'), 1, 1, '');

	RETURN QUERY
	SELECT BC.BoardNo, BC.ModUserNo, 
		CASE WHEN STRPOS(BB.Name, '{')>0 THEN (SELECT /* /* TOP 1 */ */ StringValue FROM ParseJson(BB.Name)  WHERE NAME='EN') ELSE BB.Name END  AS BoardName,
		CASE WHEN LanguageSign = 'EN' THEN COALESCE(OU.Name_EN,OU.Name) ELSE OU.Name END AS ModUserName,
		BC.ModPositionNo,
		CASE WHEN LanguageSign = 'EN' THEN COALESCE(OP.Name_EN ,OP.Name) ELSE OP.Name  END AS ModPositionName,
		BC.ModDepartNo,
		CASE WHEN LanguageSign = 'EN' THEN COALESCE(OD.Name_EN ,OD.Name) ELSE  OD.Name  END AS ModDepartName,
		BC.RegDate, BC.ModDate, BC.Title, BC.TitleEffect, BC.GroupNo, BC.Depth, BC.OrderNo, BC.HeadNo, BC.IsNotice, BC.Content, BC.IsFile, BC.FileCount,
		BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount, BC.StartDate, BC.EndDate,
		COALESCE(BH.Name, '') AS HeadName, FALSE AS IsRecommended,

		BC.RegUserNo, 
		CASE WHEN LanguageSign = 'EN' THEN COALESCE(GOU.Name_EN,GOU.Name) ELSE GOU.Name END AS RegUserName,
		BC.RegPositionNo,
		CASE WHEN LanguageSign = 'EN' THEN COALESCE(GOP.Name_EN ,OP.Name) ELSE GOP.Name  END AS RegPositionName,
		BC.RegDepartNo,
		CASE WHEN LanguageSign = 'EN' THEN COALESCE(GOD.Name_EN ,GOD.Name) ELSE  GOD.Name  END AS RegDepartName
		,BC.IsAlarm
		--,ShareDepart+ShareUser AS ShareList
	FROM Board_Contents BC
	LEFT JOIN Board_Heads BH ON BH.HeadNo = BC.HeadNo
	LEFT JOIN Board_Boards BB ON BB.BoardNo=BC.BoardNo
	LEFT JOIN Organization_Users OU ON OU.UserNo = BC.ModUserNo AND OU.Enabled = TRUE
	LEFT JOIN Organization_Positions OP ON OP.PositionNo = BC.ModPositionNo  AND OP.Enabled = TRUE
	LEFT JOIN Organization_Departments OD ON OD.DepartNo = BC.ModPositionNo  AND OD.Enabled = TRUE
	LEFT JOIN Organization_Users GOU ON GOU.UserNo = BC.RegUserNo AND GOU.Enabled = TRUE
	LEFT JOIN Organization_Positions GOP ON GOP.PositionNo = BC.RegPositionNo  AND GOP.Enabled = TRUE
	LEFT JOIN Organization_Departments GOD ON GOD.DepartNo = BC.RegDepartNo  AND GOD.Enabled = TRUE
	
	WHERE ContentNo = board_getboardcontentinfo.contentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
