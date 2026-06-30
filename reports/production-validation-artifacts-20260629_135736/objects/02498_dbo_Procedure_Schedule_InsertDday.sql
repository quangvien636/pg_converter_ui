-- ─── PROCEDURE→FUNCTION: schedule_insertdday ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_insertdday(integer, timestamp without time zone, character varying, integer, date, integer, date, integer, integer, integer, integer, integer, integer, boolean, boolean, boolean, boolean, integer, character varying, character varying, integer, character varying, character varying, character varying, character varying, date);
CREATE OR REPLACE FUNCTION public.schedule_insertdday(
    IN reguserno integer,
    IN regdate timestamp without time zone,
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
) RETURNS SETOF record
AS $function$
DECLARE
    ddayno integer;
-- !! WARNING: output needs manual review — see TODO comments
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
		

	DdayNo := lastval();
	RETURN QUERY
	SELECT DdayNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
