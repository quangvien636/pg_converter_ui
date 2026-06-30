-- ─── PROCEDURE→FUNCTION: schedule_updateschedulestartud ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_updateschedulestartud(date);
CREATE OR REPLACE FUNCTION public.schedule_updateschedulestartud(
    IN p_startdate date
) RETURNS void
AS $function$
BEGIN

	update ScheduleContents
	StartDate := schedule_updateschedulestartud.p_startdate,;
	OldScheduleNo = p_ScheduleNo
	WHERE ScheduleNo = p_scheduleno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
