-- ─── FUNCTION: schedule_updatecalendarcolor ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_updatecalendarcolor(integer, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.schedule_updatecalendarcolor(
    calendarno integer,
    moduserno integer,
    moddate timestamp without time zone
) RETURNS void
AS $function$
BEGIN


	UPDATE ScheduleCalendars
	SET ModUserNo = schedule_updatecalendarcolor.moduserno, ModDate = schedule_updatecalendarcolor.moddate, Color = Color
	WHERE CalendarNo = schedule_updatecalendarcolor.calendarno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
