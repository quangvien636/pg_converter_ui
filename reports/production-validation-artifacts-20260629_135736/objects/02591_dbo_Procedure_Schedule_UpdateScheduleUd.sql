-- ─── PROCEDURE→FUNCTION: schedule_updatescheduleud ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_updatescheduleud(date);
CREATE OR REPLACE FUNCTION public.schedule_updatescheduleud(
    IN p_enddate date
) RETURNS void
AS $function$
BEGIN

	update ScheduleContents
	EndDate := schedule_updatescheduleud.p_enddate,;
	OldScheduleNo = p_ScheduleNo
	WHERE ScheduleNo = p_scheduleno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
