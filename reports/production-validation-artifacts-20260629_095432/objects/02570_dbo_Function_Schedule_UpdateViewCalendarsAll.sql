-- ─── FUNCTION: schedule_updateviewcalendarsall ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_updateviewcalendarsall(integer, integer, timestamp without time zone, boolean, boolean, boolean, boolean, boolean, boolean);
CREATE OR REPLACE FUNCTION public.schedule_updateviewcalendarsall(
    userno integer,
    moduserno integer,
    moddate timestamp without time zone,
    istodoview boolean,
    isddayview boolean,
    iscompanyview boolean,
    ispersonalview boolean,
    isshareview boolean,
    isallview boolean
) RETURNS void
AS $function$
BEGIN


	UPDATE ScheduleViewCalendars SET
	    ModUserNo = schedule_updateviewcalendarsall.moduserno,
	    ModDate = schedule_updateviewcalendarsall.moddate,
		IsToDoView = schedule_updateviewcalendarsall.istodoview,
		IsDdayView = schedule_updateviewcalendarsall.isddayview,
		IsCompanyView = schedule_updateviewcalendarsall.iscompanyview,
		IsPersonalView = schedule_updateviewcalendarsall.ispersonalview,
		IsShareView = schedule_updateviewcalendarsall.isshareview,
		IsAllView = schedule_updateviewcalendarsall.isallview,
		ViewCalendars = ViewCalendars
	WHERE UserNo = schedule_updateviewcalendarsall.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
