-- ─── FUNCTION: dday_insertnotification ───────────────────────────────
DROP FUNCTION IF EXISTS public.dday_insertnotification(bigint, integer);
CREATE OR REPLACE FUNCTION public.dday_insertnotification(
    dayno bigint,
    notificationtype integer
) RETURNS TABLE(
    notino text
)
AS $function$
DECLARE
    notino bigint;
BEGIN


	INSERT INTO DDay_Notifications (DayNo, NotificationType, NotificationTime)
	VALUES (DayNo, NotificationType, NotificationTime)


	SET NotiNo = lastval()

	RETURN QUERY
	SELECT NotiNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
