-- ─── PROCEDURE→FUNCTION: schedule_insertschedule ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_insertschedule(integer, timestamp without time zone, character varying, integer, integer, character varying, integer, integer, integer, integer, integer, integer, date, date, time without time zone, time without time zone, boolean, boolean, boolean, boolean, boolean, integer, character varying, integer, character varying, character varying, character varying, double precision, double precision, boolean, integer);
CREATE OR REPLACE FUNCTION public.schedule_insertschedule(
    IN reguserno integer,
    IN regdate timestamp without time zone,
    IN title character varying,
    IN calendarno integer,
    IN divisionno integer,
    IN content character varying,
    IN repeattype integer,
    IN repeatcount integer,
    IN repeatmonth integer,
    IN repeatweek integer,
    IN repeatday integer,
    IN repeatdows integer,
    IN startdate date,
    IN enddate date,
    IN starttime time without time zone,
    IN endtime time without time zone,
    IN isallday boolean,
    IN isnotinote boolean,
    IN isnotimail boolean,
    IN isnotisms boolean,
    IN isnotipopup boolean,
    IN notitimetype integer,
    IN islunar character varying DEFAULT '0',
    IN isholiday integer DEFAULT 0,
    IN isfiveweek character varying DEFAULT '0',
    IN islastday character varying DEFAULT '0',
    IN place character varying DEFAULT '',
    IN latitude double precision DEFAULT 0,
    IN longitude double precision DEFAULT 0,
    IN iscompleted boolean DEFAULT FALSE,
    IN p_cycleno integer DEFAULT 0
) RETURNS SETOF record
AS $function$
DECLARE
    scheduleno integer;
-- !! WARNING: output needs manual review — see TODO comments
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
		

	ScheduleNo := lastval();
	RETURN QUERY
	SELECT ScheduleNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
