-- ─── PROCEDURE→FUNCTION: schedule_updatedday ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_updatedday(integer, integer, timestamp without time zone, character varying, integer, date, integer, date, integer, integer, integer, integer, integer, integer, boolean, boolean, boolean, boolean, integer, character varying, character varying, integer, character varying, character varying, character varying, character varying, date);
CREATE OR REPLACE FUNCTION public.schedule_updatedday(
    IN ddayno integer,
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN title character varying,
    IN groupno integer,
    IN doomdate date,
    IN periodyear integer,
    IN repeatenddate date,
    IN repeattype integer,
    IN repeatcount integer,
    IN repeatmonth integer,
    IN repeatweek integer,
    IN repeatday integer,
    IN repeatdows integer,
    IN isnotinote boolean,
    IN isnotimail boolean,
    IN isnotisms boolean,
    IN isnotipopup boolean,
    IN notitimetype integer,
    IN contents character varying DEFAULT '',
    IN islunar character varying DEFAULT '0',
    IN isholiday integer DEFAULT 0,
    IN isfiveweek character varying DEFAULT '0',
    IN islastday character varying DEFAULT '0',
    IN displaytype character varying DEFAULT 'D',
    IN iscomplete character varying DEFAULT 'N',
    IN completedate date DEFAULT 'GETDATE'
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
