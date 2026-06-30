-- ─── FUNCTION: dday_updatenotification ───────────────────────────────
DROP FUNCTION IF EXISTS public.dday_updatenotification(bigint, integer);
CREATE OR REPLACE FUNCTION public.dday_updatenotification(
    notino bigint,
    notificationtype integer
) RETURNS void
AS $function$
BEGIN


	UPDATE DDay_Notifications SET
		NotificationType = dday_updatenotification.notificationtype,
		NotificationTime = NotificationTime
	WHERE NotiNo = dday_updatenotification.notino;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
