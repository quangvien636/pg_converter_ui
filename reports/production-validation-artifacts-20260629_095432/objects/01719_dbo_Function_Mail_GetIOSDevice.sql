-- ─── FUNCTION: mail_getiosdevice ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_getiosdevice(integer);
CREATE OR REPLACE FUNCTION public.mail_getiosdevice(
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
	FROM Mail_IOSDevices
	WHERE UserNo = mail_getiosdevice.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
