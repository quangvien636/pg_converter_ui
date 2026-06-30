-- ─── PROCEDURE→FUNCTION: schedule_updatecalendarcolor ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_updatecalendarcolor(integer, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.schedule_updatecalendarcolor(
    IN calendarno integer,
    IN moduserno integer,
    IN moddate timestamp without time zone
) RETURNS void
AS $function$
BEGIN


	UPDATE ScheduleCalendars
	ModUserNo := schedule_updatecalendarcolor.moduserno, ModDate = schedule_updatecalendarcolor.moddate, Color = Color;
	WHERE CalendarNo = schedule_updatecalendarcolor.calendarno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
