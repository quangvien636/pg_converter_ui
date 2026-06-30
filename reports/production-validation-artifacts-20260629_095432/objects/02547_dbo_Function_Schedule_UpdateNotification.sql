-- ─── FUNCTION: schedule_updatenotification ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_updatenotification(bigint, integer);
CREATE OR REPLACE FUNCTION public.schedule_updatenotification(
    notino bigint,
    notificationtype integer
) RETURNS void
AS $function$
BEGIN


	UPDATE Schedule_Notifications SET
		NotificationType = schedule_updatenotification.notificationtype
	WHERE NotiNo = schedule_updatenotification.notino;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
