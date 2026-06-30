-- ─── PROCEDURE→FUNCTION: schedule_getschedule ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_getschedule(integer);
CREATE OR REPLACE FUNCTION public.schedule_getschedule(
    IN scheduleno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT ScheduleNo, S.RegUserNo
		, CASE WHEN p_lang = 'VN' THEN COALESCE(u.Name_VN,u.Name) 
			WHEN  p_lang = 'JP' THEN COALESCE(u.Name_JP,u.Name) 
			WHEN  p_lang = 'CH' THEN COALESCE(u.Name_CH,u.Name) 
			WHEN  p_lang = 'EN' THEN COALESCE(u.Name_EN,u.Name) 
		ELSE u.Name END AS UserName

		,COALESCE( CASE WHEN p_lang = 'VN' THEN COALESCE(P.Name_VN,P.Name) 
			WHEN  p_lang = 'JP' THEN COALESCE(P.Name_JP,P.Name) 
			WHEN  p_lang = 'CH' THEN COALESCE(P.Name_CH,P.Name) 
			WHEN  p_lang = 'EN' THEN COALESCE(P.Name_EN,P.Name) 
		ELSE P.Name END, '') AS PositionName
		,Title, CalendarNo, S.DivisionNo
		, CASE WHEN p_lang = 'VN' THEN COALESCE(D.NameVn,D.Name) 
			WHEN  p_lang = 'JP' THEN COALESCE(D.NameJp,D.Name) 
			WHEN  p_lang = 'CH' THEN COALESCE(D.NameCh,D.Name) 
			WHEN  p_lang = 'EN' THEN COALESCE(D.NameEn,D.Name) 
		ELSE D.Name END AS DivisionName
		, Content,
		S.IsLunar, S.IsHoliday, S.IsFiveWeek, S.IsLastDay,
		RepeatType, RepeatCount, RepeatMonth, RepeatWeek, RepeatDay, RepeatDOWs,
		StartDate, EndDate, StartTime, EndTime, IsAllDay,
		IsNotiNote, IsNotiMail, IsNotiSMS, IsNotiPopup, NotiTimeType,
		Place, Latitude, Longitude
		, COALESCE(s.IsCompleted,0) IsCompleted ---2023-01-27
		, Idea = COALESCE(Idea, '')
		, COALESCE(s.CycleNo,0) CycleNo
		, CASE WHEN p_lang = 'VN' THEN COALESCE(C.NameVn,COALESCE(C.Name,'')) 
			WHEN  p_lang = 'JP' THEN COALESCE(C.NameJp,COALESCE(C.Name,'')) 
			WHEN  p_lang = 'CH' THEN COALESCE(C.NameCh,COALESCE(C.Name,'')) 
			WHEN  p_lang = 'EN' THEN COALESCE(C.NameEn,COALESCE(C.Name,'')) 
		ELSE COALESCE(C.Name,'') END AS CycleName
	FROM ScheduleContents S 
	LEFT JOIN Organization_Users U  ON U.UserNo = S.RegUserNo
	LEFT JOIN (select UserNo, max(PositionNo) PositionNo from  Organization_BelongToDepartment group by UserNo) B  ON B.UserNo = U.UserNo
	LEFT JOIN Organization_Positions P  ON P.PositionNo = B.PositionNo
	LEFT JOIN ScheduleDivisions D  ON D.DivisionNo = S.DivisionNo
	LEFT JOIN ScheduleCycles C ON S.CycleNo = C.CycleNo
	WHERE ScheduleNo = schedule_getschedule.scheduleno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
