-- ─── FUNCTION: dday_getnotifications ───────────────────────────────
DROP FUNCTION IF EXISTS public.dday_getnotifications(bigint);
CREATE OR REPLACE FUNCTION public.dday_getnotifications(
    dayno bigint
) RETURNS TABLE(
    notino text,
    notificationtype text,
    notificationtime text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT NotiNo, NotificationType, NotificationTime
	FROM DDay_Notifications WHERE DayNo = dday_getnotifications.dayno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
