-- ─── FUNCTION: schedule_updateviewcalendarsfortodo ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_updateviewcalendarsfortodo(integer, integer, timestamp without time zone, boolean);
CREATE OR REPLACE FUNCTION public.schedule_updateviewcalendarsfortodo(
    userno integer,
    moduserno integer,
    moddate timestamp without time zone,
    istodoview boolean
) RETURNS void
AS $function$
BEGIN


	UPDATE ScheduleViewCalendars SET
	    ModUserNo = schedule_updateviewcalendarsfortodo.moduserno,
	    ModDate = schedule_updateviewcalendarsfortodo.moddate,
		IsToDoView = schedule_updateviewcalendarsfortodo.istodoview
	WHERE UserNo = schedule_updateviewcalendarsfortodo.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
