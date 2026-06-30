-- ─── PROCEDURE→FUNCTION: board_getboardcontent ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.board_getboardcontent(integer, character varying);
CREATE OR REPLACE FUNCTION public.board_getboardcontent(
    IN contentno integer DEFAULT 10127,
    IN languagesign character varying DEFAULT 'EN'
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT 
	BC.ContentNo, 
	BC.BoardNo  
	, BC.ModUserNo, 
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end) as ModUserName,
		BC.ModPositionNo,
		COALESCE(( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end),'') as ModPositionName,
		 BC.ModDepartNo,
		COALESCE(( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end),'') as ModDepartName,
		BC.RegDate, BC.ModDate, BC.Title, BC.TitleEffect, BC.GroupNo, BC.Depth, BC.OrderNo, BC.HeadNo, BC.IsNotice, BC.Content, BC.IsFile, BC.FileCount,
		BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount, BC.StartDate, BC.EndDate,
		
		COALESCE(BH.Name, '') AS HeadName,

		BC.RegUserNo, 
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
		BC.RegPositionNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
		 BC.RegDepartNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
		,BC.IsAlarm
		,BC.Type
		,BC.ErrorType
		,BC.PersonType
		,BC.VisitDate
		,BC.VisitCompleteDate
		,BC.BusinessDate
		,BC.DateView
		,BC.DesignNo
		,BC.ConstructionName
		,BC.ApplyTo
		,CASE WHEN BC.DateView IS NULL THEN NULL ELSE (BC.DateView::date - BC.RegDate::date)  END AS DayDateView,
		BC.Important
		,BC.MailRecipientNo
		,BC.MailRecipientName
		,BC.Private
		,BC.Purpose
		,BC.Note
		,BC.Other
		,BC.Inspector
		,BC.Generation
		,BC.BadNo
		,BC.Standard
		,BC.IsNotice
		,BC.RecommendedCount
		,COALESCE(BC.IsRecommendPublic,'FALSE') AS IsRecommendPublic
		,BC.RootId
		,BC.EappNo 
		,BC.IsShareAll 
		,BC.StartDate
		,BC.EndDate 
		,'' AS ShareNameList
		,'' AS ShareNoList
		FROM Board_Contents BC
	LEFT JOIN Board_Heads BH ON BH.HeadNo = BC.HeadNo
	WHERE ContentNo = board_getboardcontent.contentno And BC.Enabled = TRUE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
