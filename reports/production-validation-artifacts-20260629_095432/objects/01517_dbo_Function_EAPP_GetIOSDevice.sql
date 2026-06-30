-- ─── FUNCTION: eapp_getiosdevice ───────────────────────────────
DROP FUNCTION IF EXISTS public.eapp_getiosdevice(integer);
CREATE OR REPLACE FUNCTION public.eapp_getiosdevice(
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
	FROM EAPP_IOSDevices
	WHERE UserNo = eapp_getiosdevice.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
