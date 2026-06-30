-- ─── PROCEDURE→FUNCTION: schedule_updateviewcalendarsfortodo ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_updateviewcalendarsfortodo(integer, integer, timestamp without time zone, boolean);
CREATE OR REPLACE FUNCTION public.schedule_updateviewcalendarsfortodo(
    IN userno integer,
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN istodoview boolean
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
