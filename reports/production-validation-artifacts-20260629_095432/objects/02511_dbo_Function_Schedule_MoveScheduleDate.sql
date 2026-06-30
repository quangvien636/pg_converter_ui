-- ─── FUNCTION: schedule_movescheduledate ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_movescheduledate(integer, date);
CREATE OR REPLACE FUNCTION public.schedule_movescheduledate(
    scheduleno integer,
    changedate date
) RETURNS TABLE(
    col1 text,
    col2 text
)
-- TODO: DATEADD was not fully converted; use interval arithmetic
AS $function$
DECLARE
    startdate date;
    enddate date;
    day integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN




	SELECT StartDate = StartDate, EndDate = EndDate FROM ScheduleContents WHERE ScheduleNo = schedule_movescheduledate.scheduleno
	SELECT DAY = DATEDIFF(dd,StartDate,ChangeDate)
	
	UPDATE ScheduleContents
	SET
		ModDate = NOW(),
		ModUserNo = UserNo,
		StartDate = DATEADD(dd, DAY, StartDate),
		EndDate = DATEADD(dd, DAY, EndDate)
	WHERE ScheduleNo = schedule_movescheduledate.scheduleno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
