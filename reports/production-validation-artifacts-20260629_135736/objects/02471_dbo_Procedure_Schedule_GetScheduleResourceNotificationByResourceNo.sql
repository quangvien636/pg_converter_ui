-- ─── PROCEDURE→FUNCTION: schedule_getscheduleresourcenotificationbyresourceno ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_getscheduleresourcenotificationbyresourceno(integer);
CREATE OR REPLACE FUNCTION public.schedule_getscheduleresourcenotificationbyresourceno(
    IN resourceno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	select NotificationNo,ResourceNo,NotificationType,AlarmTime
	from ScheduleResourceNotifications where ResourceNo = schedule_getscheduleresourcenotificationbyresourceno.resourceno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
