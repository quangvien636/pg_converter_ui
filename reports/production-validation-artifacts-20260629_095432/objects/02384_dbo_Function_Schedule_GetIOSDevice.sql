-- ─── FUNCTION: schedule_getiosdevice ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getiosdevice(integer);
CREATE OR REPLACE FUNCTION public.schedule_getiosdevice(
    userno integer
) RETURNS TABLE(
    deviceno text,
    regdate text,
    deviceid text,
    osversion text,
    notificationoptions text,
    timezoneoffset text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT DeviceNo, RegDate, DeviceID, OSVersion, NotificationOptions, TimezoneOffset
	FROM Schedule_IOSDevices
	WHERE UserNo = schedule_getiosdevice.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
