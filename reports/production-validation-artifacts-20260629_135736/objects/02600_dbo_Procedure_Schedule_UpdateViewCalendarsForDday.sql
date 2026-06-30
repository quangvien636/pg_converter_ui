-- ─── PROCEDURE→FUNCTION: schedule_updateviewcalendarsfordday ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_updateviewcalendarsfordday(integer, integer, timestamp without time zone, boolean);
CREATE OR REPLACE FUNCTION public.schedule_updateviewcalendarsfordday(
    IN userno integer,
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN isddayview boolean
) RETURNS void
AS $function$
BEGIN


	UPDATE ScheduleViewCalendars SET
	    ModUserNo = schedule_updateviewcalendarsfordday.moduserno,
	    ModDate = schedule_updateviewcalendarsfordday.moddate,
		IsDdayView = schedule_updateviewcalendarsfordday.isddayview
	WHERE UserNo = schedule_updateviewcalendarsfordday.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
