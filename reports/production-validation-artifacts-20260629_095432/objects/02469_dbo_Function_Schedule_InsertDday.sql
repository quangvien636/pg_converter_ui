-- ─── FUNCTION: schedule_insertdday ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_insertdday(integer, timestamp without time zone, character varying, integer, date, integer, date, integer, integer, integer, integer, integer, integer, boolean, boolean, boolean, boolean, integer, character varying, character varying, integer, character varying, character varying, character varying, character varying, date);
CREATE OR REPLACE FUNCTION public.schedule_insertdday(
    reguserno integer,
    regdate timestamp without time zone,
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
) RETURNS TABLE(
    ddayno text
)
AS $function$
DECLARE
    ddayno integer;
BEGIN


	INSERT INTO ScheduleDdays (
		RegUserNo, RegDate, ModUserNo, ModDate, Title, Contents, GroupNo, DoomDate, IsLunar, IsHoliday, IsFiveWeek, IsLastDay, PeriodYear,
		RepeatEndDate, RepeatType, RepeatCount, RepeatMonth, RepeatWeek, RepeatDay, RepeatDOWs,
		IsNotiNote, IsNotiMail, IsNotiSMS, IsNotiPopup, NotiTimeType,
		DisplayType, IsComplete, CompleteDate)
	VALUES (RegUserNo, RegDate, RegUserNo, RegDate, Title, Contents, GroupNo, DoomDate, IsLunar, IsHoliday, IsFiveWeek, IsLastDay, PeriodYear,
		RepeatEndDate, RepeatType, RepeatCount, RepeatMonth, RepeatWeek, RepeatDay, RepeatDOWs,
		IsNotiNote, IsNotiMail, IsNotiSMS, IsNotiPopup, NotiTimeType,
		DisplayType, IsComplete, CompleteDate)
		

	SET DdayNo = lastval()
	
	RETURN QUERY
	SELECT DdayNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
