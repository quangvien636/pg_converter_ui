-- ─── FUNCTION: schedule_insertschedule ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_insertschedule(integer, timestamp without time zone, character varying, integer, integer, character varying, integer, integer, integer, integer, integer, integer, date, date, time without time zone, time without time zone, boolean, boolean, boolean, boolean, boolean, integer, character varying, integer, character varying, character varying, character varying, double precision, double precision, boolean, integer);
CREATE OR REPLACE FUNCTION public.schedule_insertschedule(
    reguserno integer,
    regdate timestamp without time zone,
    title character varying,
    calendarno integer,
    divisionno integer,
    content character varying,
    repeattype integer,
    repeatcount integer,
    repeatmonth integer,
    repeatweek integer,
    repeatday integer,
    repeatdows integer,
    startdate date,
    enddate date,
    starttime time without time zone,
    endtime time without time zone,
    isallday boolean,
    isnotinote boolean,
    isnotimail boolean,
    isnotisms boolean,
    isnotipopup boolean,
    notitimetype integer,
    islunar character varying DEFAULT '0',
    isholiday integer DEFAULT 0,
    isfiveweek character varying DEFAULT '0',
    islastday character varying DEFAULT '0',
    place character varying DEFAULT '',
    latitude double precision DEFAULT 0,
    longitude double precision DEFAULT 0,
    iscompleted boolean DEFAULT FALSE,
    p_cycleno integer DEFAULT 0
) RETURNS TABLE(
    scheduleno text
)
AS $function$
DECLARE
    scheduleno integer;
BEGIN


	INSERT INTO ScheduleContents (
		RegUserNo, RegDate, ModUserNo, ModDate, Title, CalendarNo, DivisionNo, Content,
		IsLunar, IsHoliday, IsFiveWeek, IsLastDay,
		RepeatType, RepeatCount, RepeatMonth, RepeatWeek, RepeatDay, RepeatDOWs,
		StartDate, EndDate, StartTime, EndTime, IsAllDay,
		IsNotiNote, IsNotiMail, IsNotiSMS, IsNotiPopup, NotiTimeType,
		Place, Latitude, Longitude, IsCompleted, CycleNo)
	VALUES (RegUserNo, RegDate, RegUserNo, RegDate, Title, CalendarNo, DivisionNo, Content,
		IsLunar, IsHoliday, IsFiveWeek, IsLastDay,
		RepeatType, RepeatCount, RepeatMonth, RepeatWeek, RepeatDay, RepeatDOWs,
		StartDate, EndDate, StartTime, EndTime, IsAllDay,
		IsNotiNote, IsNotiMail, IsNotiSMS, IsNotiPopup, NotiTimeType,
		Place, Latitude, Longitude, IsCompleted, p_cycleNo)
		

	SET ScheduleNo = lastval()
	
	RETURN QUERY
	SELECT ScheduleNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
