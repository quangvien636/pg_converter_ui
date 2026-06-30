-- ─── FUNCTION: schedule_movecontent ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_movecontent(date, time without time zone, date, time without time zone, boolean, integer);
CREATE OR REPLACE FUNCTION public.schedule_movecontent(
    startdate date,
    starttime time without time zone,
    enddate date,
    endtime time without time zone,
    isallday boolean,
    userno integer
) RETURNS void
AS $function$
BEGIN

	UPDATE ScheduleContents
	SET
		StartDate = schedule_movecontent.startdate,
		StartTime = schedule_movecontent.starttime,
		EndDate = schedule_movecontent.enddate,
		EndTime = schedule_movecontent.endtime,
		IsAllDay = schedule_movecontent.isallday,
		ModDate = NOW(),
		ModUserNo = schedule_movecontent.userno
	WHERE ScheduleNo = ScheduleNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
