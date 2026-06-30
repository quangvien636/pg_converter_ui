-- ─── PROCEDURE→FUNCTION: schedule_deletecalendarpermision ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_deletecalendarpermision(integer);
CREATE OR REPLACE FUNCTION public.schedule_deletecalendarpermision(
    IN p_cno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM ScheduleCalendarPermisions WHERE CalendarNo = schedule_deletecalendarpermision.p_cno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
