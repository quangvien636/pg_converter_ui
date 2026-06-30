-- ─── PROCEDURE→FUNCTION: schedule_deleteschedulesharers ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_deleteschedulesharers(integer);
CREATE OR REPLACE FUNCTION public.schedule_deleteschedulesharers(
    IN scheduleno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM ScheduleContentSharers WHERE ScheduleNo = schedule_deleteschedulesharers.scheduleno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
