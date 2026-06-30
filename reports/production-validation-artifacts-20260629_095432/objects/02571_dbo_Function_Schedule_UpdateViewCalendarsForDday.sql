-- ─── FUNCTION: schedule_updateviewcalendarsfordday ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_updateviewcalendarsfordday(integer, integer, timestamp without time zone, boolean);
CREATE OR REPLACE FUNCTION public.schedule_updateviewcalendarsfordday(
    userno integer,
    moduserno integer,
    moddate timestamp without time zone,
    isddayview boolean
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
