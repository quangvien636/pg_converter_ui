-- ─── PROCEDURE→FUNCTION: schedule_insertscheduleud ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_insertscheduleud(integer, date);
CREATE OR REPLACE FUNCTION public.schedule_insertscheduleud(
    IN p_scheduleno integer,
    IN p_startdate date
) RETURNS SETOF record
AS $function$
DECLARE
    p_scheduleno2 integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO ScheduleContents (
		RegUserNo, RegDate, ModUserNo, ModDate, Title, CalendarNo, DivisionNo, Content,
		IsLunar, IsHoliday, IsFiveWeek, IsLastDay,
		RepeatType, RepeatCount, RepeatMonth, RepeatWeek, RepeatDay, RepeatDOWs,
		StartDate, EndDate, StartTime, EndTime, IsAllDay,
		IsNotiNote, IsNotiMail, IsNotiSMS, IsNotiPopup, NotiTimeType,
		Place, Latitude, Longitude, IsCompleted, CycleNo, OldScheduleNo)
	 
	RETURN QUERY
	select RegUserNo, RegDate, ModUserNo, ModDate, Title, CalendarNo, DivisionNo, Content,
		IsLunar, IsHoliday, IsFiveWeek, IsLastDay,
		RepeatType, RepeatCount, RepeatMonth, RepeatWeek, RepeatDay, RepeatDOWs,
		p_StartDate, EndDate, StartTime, EndTime, IsAllDay,
		IsNotiNote, IsNotiMail, IsNotiSMS, IsNotiPopup, NotiTimeType,
		Place, Latitude, Longitude, IsCompleted, CycleNo, p_ScheduleNo
	from ScheduleContents	where ScheduleNo = schedule_insertscheduleud.p_scheduleno

	p_ScheduleNo2 := lastval();
	RETURN QUERY
	SELECT p_ScheduleNo2;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
