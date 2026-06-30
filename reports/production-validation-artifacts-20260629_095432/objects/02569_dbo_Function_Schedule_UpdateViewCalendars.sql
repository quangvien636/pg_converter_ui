-- ─── FUNCTION: schedule_updateviewcalendars ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_updateviewcalendars(integer, integer, timestamp without time zone, boolean, boolean);
CREATE OR REPLACE FUNCTION public.schedule_updateviewcalendars(
    userno integer,
    moduserno integer,
    moddate timestamp without time zone,
    istodoview boolean,
    isddayview boolean
) RETURNS void
AS $function$
BEGIN


	UPDATE ScheduleViewCalendars SET
	    ModUserNo = schedule_updateviewcalendars.moduserno,
	    ModDate = schedule_updateviewcalendars.moddate,
		IsToDoView = schedule_updateviewcalendars.istodoview,
		IsDdayView = schedule_updateviewcalendars.isddayview,
		ViewCalendars = ViewCalendars
	WHERE UserNo = schedule_updateviewcalendars.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
