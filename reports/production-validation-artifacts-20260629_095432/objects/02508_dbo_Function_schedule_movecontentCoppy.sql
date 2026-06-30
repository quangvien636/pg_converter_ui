-- ─── FUNCTION: schedule_movecontentcoppy ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_movecontentcoppy(date, time without time zone, date, time without time zone, boolean, integer);
CREATE OR REPLACE FUNCTION public.schedule_movecontentcoppy(
    p_startdate date,
    p_starttime time without time zone,
    p_enddate date,
    p_endtime time without time zone,
    p_isallday boolean,
    p_userno integer
) RETURNS TABLE(
    p_userno text,
    col2 text,
    p_userno text,
    col4 text,
    title text,
    calendarno text,
    divisionno text,
    content text,
    islunar text,
    isholiday text,
    isfiveweek text,
    islastday text,
    repeattype text,
    repeatcount text,
    repeatmonth text,
    repeatweek text,
    repeatday text,
    repeatdows text,
    p_startdate text,
    p_enddate text,
    p_starttime text,
    p_endtime text,
    p_isallday text,
    isnotinote text,
    isnotimail text,
    isnotisms text,
    0 text,
    notitimetype text
)
AS $function$
DECLARE
    scheduleno integer;
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

		SET ScheduleNo = lastval()
	
		RETURN QUERY
		SELECT ScheduleNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
