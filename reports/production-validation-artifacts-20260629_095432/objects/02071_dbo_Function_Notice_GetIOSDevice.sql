-- ─── FUNCTION: notice_getiosdevice ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_getiosdevice(integer);
CREATE OR REPLACE FUNCTION public.notice_getiosdevice(
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
	FROM Notice_IOSDevices
	WHERE UserNo = notice_getiosdevice.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
