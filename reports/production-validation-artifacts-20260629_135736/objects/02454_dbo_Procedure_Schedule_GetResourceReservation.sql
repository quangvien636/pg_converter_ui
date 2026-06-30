-- ─── PROCEDURE→FUNCTION: schedule_getresourcereservation ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_getresourcereservation(integer);
CREATE OR REPLACE FUNCTION public.schedule_getresourcereservation(
    IN reservationno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT ReservationNo, S.RegUserNo
		,CASE WHEN p_lang = 'VN' THEN COALESCE(u.Name_VN,u.Name) 
			WHEN  p_lang = 'JP' THEN COALESCE(u.Name_JP,u.Name) 
			WHEN  p_lang = 'CH' THEN COALESCE(u.Name_CH,u.Name) 
			WHEN  p_lang = 'EN' THEN COALESCE(u.Name_EN,u.Name) 
		ELSE u.Name END AS UserName
		,CASE WHEN p_lang = 'VN' THEN COALESCE(P.Name_VN,P.Name) 
			WHEN  p_lang = 'JP' THEN COALESCE(P.Name_JP,P.Name) 
			WHEN  p_lang = 'CH' THEN COALESCE(P.Name_CH,P.Name) 
			WHEN  p_lang = 'EN' THEN COALESCE(P.Name_EN,P.Name) 
		ELSE P.Name END AS PositionName
		,Title, S.ResourceNo, R.Name AS ResourceName, Content,
		RepeatType, RepeatCount, RepeatMonth, RepeatWeek, RepeatDay, RepeatDOWs,
		StartDate, EndDate, StartTime, EndTime,
		IsNotiNote, IsNotiMail, IsNotiSMS, IsNotiPopup, NotiTimeType
		,COALESCE( R.IsHidenReg,0) IsHidenReg
		,COALESCE( S.IsAllDay,0) IsAllDay
		, s.RsvnStatus --2024
	FROM ScheduleResourceReservations S
	INNER JOIN Organization_Users U ON U.UserNo = S.RegUserNo
	INNER JOIN Organization_BelongToDepartment B ON B.UserNo = U.UserNo
	INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
	INNER JOIN ScheduleResources R ON R.ResourceNo = S.ResourceNo
	WHERE ReservationNo = schedule_getresourcereservation.reservationno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
