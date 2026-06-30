-- ─── PROCEDURE→FUNCTION: schedule_movecontent ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_movecontent(date, time without time zone, date, time without time zone, boolean, integer);
CREATE OR REPLACE FUNCTION public.schedule_movecontent(
    IN startdate date,
    IN starttime time without time zone,
    IN enddate date,
    IN endtime time without time zone,
    IN isallday boolean,
    IN userno integer
) RETURNS void
AS $function$
BEGIN

	UPDATE ScheduleContents
	StartDate := schedule_movecontent.startdate,;
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
