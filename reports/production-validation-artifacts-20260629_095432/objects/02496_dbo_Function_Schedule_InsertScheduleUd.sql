-- ─── FUNCTION: schedule_insertscheduleud ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_insertscheduleud(integer, date);
CREATE OR REPLACE FUNCTION public.schedule_insertscheduleud(
    p_scheduleno integer,
    p_startdate date
) RETURNS TABLE(
    reguserno text,
    regdate text,
    moduserno text,
    moddate text,
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
    enddate text,
    starttime text,
    endtime text,
    isallday text,
    isnotinote text,
    isnotimail text,
    isnotisms text,
    isnotipopup text,
    notitimetype text,
    place text,
    latitude text,
    longitude text,
    iscompleted text,
    cycleno text,
    p_scheduleno text
)
AS $function$
DECLARE
    p_scheduleno2 integer;
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

	SET p_ScheduleNo2 = lastval()
	
	RETURN QUERY
	SELECT p_ScheduleNo2;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
