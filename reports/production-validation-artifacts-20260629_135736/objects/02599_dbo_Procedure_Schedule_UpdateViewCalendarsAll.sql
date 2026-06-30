-- ─── PROCEDURE→FUNCTION: schedule_updateviewcalendarsall ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_updateviewcalendarsall(integer, integer, timestamp without time zone, boolean, boolean, boolean, boolean, boolean, boolean);
CREATE OR REPLACE FUNCTION public.schedule_updateviewcalendarsall(
    IN userno integer,
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN istodoview boolean,
    IN isddayview boolean,
    IN iscompanyview boolean,
    IN ispersonalview boolean,
    IN isshareview boolean,
    IN isallview boolean
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
