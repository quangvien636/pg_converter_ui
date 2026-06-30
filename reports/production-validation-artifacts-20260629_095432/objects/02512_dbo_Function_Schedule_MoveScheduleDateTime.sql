-- ─── FUNCTION: schedule_movescheduledatetime ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_movescheduledatetime(integer, date, time without time zone);
CREATE OR REPLACE FUNCTION public.schedule_movescheduledatetime(
    scheduleno integer,
    changedate date,
    changetime time without time zone
) RETURNS TABLE(
    col1 text,
    col2 text,
    col3 text,
    col4 text
)
-- TODO: DATEADD was not fully converted; use interval arithmetic
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







	RETURN QUERY
	SELECT 
		StartDate = StartDate, EndDate = EndDate, 
		StartTime = StartTime, EndTime = EndTime
	FROM ScheduleContents 
	WHERE ScheduleNo = schedule_movescheduledatetime.scheduleno
	SELECT DAY = DATEDIFF(dd,StartDate,ChangeDate)
	SELECT MIN = DATEDIFF(mi,StartTime,ChangeTime)
	
	UPDATE ScheduleContents
	SET
		ModDate = NOW(),
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
