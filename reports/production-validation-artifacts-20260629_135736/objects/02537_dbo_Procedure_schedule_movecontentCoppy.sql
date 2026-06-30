-- ─── PROCEDURE→FUNCTION: schedule_movecontentcoppy ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_movecontentcoppy(date, time without time zone, date, time without time zone, boolean, integer);
CREATE OR REPLACE FUNCTION public.schedule_movecontentcoppy(
    IN p_startdate date,
    IN p_starttime time without time zone,
    IN p_enddate date,
    IN p_endtime time without time zone,
    IN p_isallday boolean,
    IN p_userno integer
) RETURNS SETOF record
AS $function$
DECLARE
    scheduleno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	insert into ScheduleContents(RegUserNo,	RegDate,ModUserNo, ModDate,Title,CalendarNo,DivisionNo,Content,IsLunar,IsHoliday,IsFiveWeek,IsLastDay,RepeatType,RepeatCount,RepeatMonth,RepeatWeek,RepeatDay,RepeatDOWs,StartDate,EndDate,StartTime,EndTime,IsAllDay,IsNotiNote,IsNotiMail,IsNotiSMS, isnotipopup,notitimetype)
		RETURN QUERY
		select
			p_userno
			,NOW()
			,p_userno
			,NOW()
			,Title
			,CalendarNo
			,DivisionNo
			,Content
			,IsLunar
			,IsHoliday,IsFiveWeek,IsLastDay,RepeatType,RepeatCount,RepeatMonth,RepeatWeek,RepeatDay,RepeatDOWs
			,p_startdate
			,p_enddate
			,p_starttime
			,p_endtime
			,p_isallday,IsNotiNote,IsNotiMail,IsNotiSMS, 0, notitimetype
		from ScheduleContents
		WHERE ScheduleNo = p_scheduleno;

		ScheduleNo := lastval();
		RETURN QUERY
		SELECT ScheduleNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
