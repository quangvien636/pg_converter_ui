-- ─── FUNCTION: schedule_updateschedule ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_updateschedule(integer, integer, timestamp without time zone, character varying, integer, integer, character varying, integer, integer, integer, integer, integer, integer, date, date, time without time zone, time without time zone, boolean, boolean, boolean, boolean, boolean, integer, character varying, character varying, integer, character varying, character varying, character varying, double precision, double precision, boolean, integer);
CREATE OR REPLACE FUNCTION public.schedule_updateschedule(
    scheduleno integer,
    moduserno integer,
    moddate timestamp without time zone,
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
    idea character varying,
    islunar character varying DEFAULT '0',
    isholiday integer DEFAULT 0,
    isfiveweek character varying DEFAULT '0',
    islastday character varying DEFAULT '0',
    place character varying DEFAULT '',
    latitude double precision DEFAULT 0,
    longitude double precision DEFAULT 0,
    iscompleted boolean DEFAULT FALSE,
    p_cycleno integer DEFAULT 0
) RETURNS void
AS $function$
BEGIN



									FROM ScheduleContents S
									LEFT JOIN ScheduleCalendarSetup C ON S.RegUserNo = C.UserNo
									WHERE C.IsFunctionComplete = TRUE AND S.ScheduleNo = schedule_updateschedule.scheduleno)

	UPDATE ScheduleContents SET
		ModUserNo = schedule_updateschedule.moduserno,
		ModDate = schedule_updateschedule.moddate,
		Title = schedule_updateschedule.title,
		CalendarNo = schedule_updateschedule.calendarno,
		DivisionNo = schedule_updateschedule.divisionno,
		Content = schedule_updateschedule.content,
		IsLunar = schedule_updateschedule.islunar,
		IsHoliday = schedule_updateschedule.isholiday,
		IsFiveWeek = schedule_updateschedule.isfiveweek,
		IsLastDay = schedule_updateschedule.islastday,
		RepeatType = schedule_updateschedule.repeattype,
		RepeatCount = schedule_updateschedule.repeatcount,
		RepeatMonth = schedule_updateschedule.repeatmonth,
		RepeatWeek = schedule_updateschedule.repeatweek,
		RepeatDay = schedule_updateschedule.repeatday,
		RepeatDOWs = schedule_updateschedule.repeatdows,
		StartDate = schedule_updateschedule.startdate,
		EndDate = schedule_updateschedule.enddate,
		StartTime = schedule_updateschedule.starttime,
		EndTime = schedule_updateschedule.endtime,
		IsAllDay = schedule_updateschedule.isallday,
		IsNotiNote = schedule_updateschedule.isnotinote,
		IsNotiMail = schedule_updateschedule.isnotimail,
		IsNotiSMS = schedule_updateschedule.isnotisms,
		IsNotiPopup = schedule_updateschedule.isnotipopup,
		NotiTimeType = schedule_updateschedule.notitimetype,
		Place = schedule_updateschedule.place,
		Latitude = schedule_updateschedule.latitude,
		Longitude = schedule_updateschedule.longitude,
		IsCompleted = CASE WHEN IsFuncComplete = TRUE THEN IsCompleted ELSE IsCompleted END,
		Idea = schedule_updateschedule.idea,
		CycleNo = schedule_updateschedule.p_cycleno
		
		
	WHERE ScheduleNo = schedule_updateschedule.scheduleno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
