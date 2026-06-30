-- ─── FUNCTION: schedule_getscheduleresourcenotificationbyresourceno ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getscheduleresourcenotificationbyresourceno(integer);
CREATE OR REPLACE FUNCTION public.schedule_getscheduleresourcenotificationbyresourceno(
    resourceno integer
) RETURNS TABLE(
    notificationno text,
    resourceno text,
    notificationtype text,
    alarmtime text
)
AS $function$
BEGIN

	RETURN QUERY
	select NotificationNo,ResourceNo,NotificationType,AlarmTime
	from ScheduleResourceNotifications where ResourceNo = schedule_getscheduleresourcenotificationbyresourceno.resourceno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
