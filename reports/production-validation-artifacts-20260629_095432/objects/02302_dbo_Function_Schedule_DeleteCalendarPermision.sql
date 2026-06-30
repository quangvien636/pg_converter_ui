-- ─── FUNCTION: schedule_deletecalendarpermision ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_deletecalendarpermision(integer);
CREATE OR REPLACE FUNCTION public.schedule_deletecalendarpermision(
    p_cno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM ScheduleCalendarPermisions WHERE CalendarNo = schedule_deletecalendarpermision.p_cno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
