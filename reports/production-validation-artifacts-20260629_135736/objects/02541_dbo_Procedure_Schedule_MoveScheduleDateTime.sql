-- ─── PROCEDURE→FUNCTION: schedule_movescheduledatetime ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: DATEADD was not fully converted; use interval arithmetic
DROP FUNCTION IF EXISTS public.schedule_movescheduledatetime(integer, date, time without time zone);
CREATE OR REPLACE FUNCTION public.schedule_movescheduledatetime(
    IN scheduleno integer,
    IN changedate date,
    IN changetime time without time zone
) RETURNS SETOF record
AS $function$
DECLARE
    startdate date;
    enddate date;
    starttime time without time zone;
    endtime time without time zone;
    day integer;
    min integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN







	SELECT StartDate, EndDate, StartTime INTO startdate, enddate, starttime FROM ScheduleContents 
	WHERE ScheduleNo = schedule_movescheduledatetime.scheduleno
	DAY := (DATEDIFF(dd,StartDate,ChangeDate));
	MIN := (DATEDIFF(mi,StartTime,ChangeTime));;
	UPDATE ScheduleContents
	ModDate := NOW(),;
		ModUserNo = UserNo,
		StartDate = DATEADD(dd, DAY, StartDate),
		EndDate = DATEADD(dd, DAY, EndDate),
		StartTime = DATEADD(mi, MIN, StartTime),
		EndTime = DATEADD(mi, MIN, EndTime)
	WHERE ScheduleNo = schedule_movescheduledatetime.scheduleno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
