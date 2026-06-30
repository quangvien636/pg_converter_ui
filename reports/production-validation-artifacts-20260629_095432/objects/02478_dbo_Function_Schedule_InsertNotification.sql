-- ─── FUNCTION: schedule_insertnotification ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_insertnotification(bigint, integer);
CREATE OR REPLACE FUNCTION public.schedule_insertnotification(
    scheduleno bigint,
    notificationtype integer
) RETURNS TABLE(
    notino text
)
AS $function$
DECLARE
    notino bigint;
BEGIN


	INSERT INTO Schedule_Notifications (ScheduleNo, NotificationType)
	VALUES (ScheduleNo, NotificationType)


	SET NotiNo = lastval()

	RETURN QUERY
	SELECT NotiNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
