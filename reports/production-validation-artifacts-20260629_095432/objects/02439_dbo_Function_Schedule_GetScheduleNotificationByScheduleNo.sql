-- ─── FUNCTION: schedule_getschedulenotificationbyscheduleno ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getschedulenotificationbyscheduleno(integer);
CREATE OR REPLACE FUNCTION public.schedule_getschedulenotificationbyscheduleno(
    scheduleno integer
) RETURNS TABLE(
    notificationno text,
    scheduleno text,
    notificationtype text,
    alarmtime text
)
AS $function$
BEGIN

	RETURN QUERY
	select NotificationNo,ScheduleNo,NotificationType,AlarmTime
	from ScheduleNotifications where ScheduleNo = schedule_getschedulenotificationbyscheduleno.scheduleno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
