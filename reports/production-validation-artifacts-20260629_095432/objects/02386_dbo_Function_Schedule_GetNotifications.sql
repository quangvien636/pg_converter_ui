-- ─── FUNCTION: schedule_getnotifications ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getnotifications(integer);
CREATE OR REPLACE FUNCTION public.schedule_getnotifications(
    scheduleno integer
) RETURNS TABLE(
    notino text,
    notificationtype text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT NotiNo, NotificationType
	FROM Schedule_Notifications WHERE ScheduleNo = schedule_getnotifications.scheduleno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
