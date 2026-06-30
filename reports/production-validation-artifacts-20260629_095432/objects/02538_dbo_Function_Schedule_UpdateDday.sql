-- ─── FUNCTION: schedule_updatedday ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_updatedday(integer, integer, timestamp without time zone, character varying, integer, date, integer, date, integer, integer, integer, integer, integer, integer, boolean, boolean, boolean, boolean, integer, character varying, character varying, integer, character varying, character varying, character varying, character varying, date);
CREATE OR REPLACE FUNCTION public.schedule_updatedday(
    ddayno integer,
    moduserno integer,
    moddate timestamp without time zone,
    title character varying,
    groupno integer,
    doomdate date,
    periodyear integer,
    repeatenddate date,
    repeattype integer,
    repeatcount integer,
    repeatmonth integer,
    repeatweek integer,
    repeatday integer,
    repeatdows integer,
    isnotinote boolean,
    isnotimail boolean,
    isnotisms boolean,
    isnotipopup boolean,
    notitimetype integer,
    contents character varying DEFAULT '',
    islunar character varying DEFAULT '0',
    isholiday integer DEFAULT 0,
    isfiveweek character varying DEFAULT '0',
    islastday character varying DEFAULT '0',
    displaytype character varying DEFAULT 'D',
    iscomplete character varying DEFAULT 'N',
    completedate date DEFAULT 'GETDATE'
) RETURNS void
AS $function$
BEGIN

	
	UPDATE ScheduleDdays SET
		ModUserNo = schedule_updatedday.moduserno,
		ModDate = schedule_updatedday.moddate,
		Title = schedule_updatedday.title,
		Contents = schedule_updatedday.contents,
		GroupNo = schedule_updatedday.groupno,
		DoomDate = schedule_updatedday.doomdate,
		IsLunar = schedule_updatedday.islunar,
		IsHoliday = schedule_updatedday.isholiday,
		IsFiveWeek = schedule_updatedday.isfiveweek,
		IsLastDay = schedule_updatedday.islastday,
		PeriodYear = schedule_updatedday.periodyear,
		RepeatEndDate = schedule_updatedday.repeatenddate, 
		RepeatType = schedule_updatedday.repeattype, 
		RepeatCount = schedule_updatedday.repeatcount, 
		RepeatMonth = schedule_updatedday.repeatmonth, 
		RepeatWeek = schedule_updatedday.repeatweek, 
		RepeatDay = schedule_updatedday.repeatday, 
		RepeatDOWs = schedule_updatedday.repeatdows,
		IsNotiNote = schedule_updatedday.isnotinote,
		IsNotiMail = schedule_updatedday.isnotimail,
		IsNotiSMS = schedule_updatedday.isnotisms,
		IsNotiPopup = schedule_updatedday.isnotipopup,
		NotiTimeType = schedule_updatedday.notitimetype,
		DisplayType = schedule_updatedday.displaytype,
		IsComplete = schedule_updatedday.iscomplete,
		CompleteDate = schedule_updatedday.completedate
	WHERE DdayNo = schedule_updatedday.ddayno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
