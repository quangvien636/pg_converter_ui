-- ─── PROCEDURE→FUNCTION: schedule_deleteschedule ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_deleteschedule(integer);
CREATE OR REPLACE FUNCTION public.schedule_deleteschedule(
    IN scheduleno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM ScheduleContents WHERE ScheduleNo = schedule_deleteschedule.scheduleno;
	DELETE FROM ScheduleContentSharers WHERE ScheduleNo = schedule_deleteschedule.scheduleno;
	DELETE FROM ScheduleContentsGoogle WHERE ScheduleNo = schedule_deleteschedule.scheduleno;
	DELETE FROM Schedule_Comments WHERE ScheduleNo = schedule_deleteschedule.scheduleno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
