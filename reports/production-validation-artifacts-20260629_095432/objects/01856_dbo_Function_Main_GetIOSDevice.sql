-- ─── FUNCTION: main_getiosdevice ───────────────────────────────
DROP FUNCTION IF EXISTS public.main_getiosdevice(integer);
CREATE OR REPLACE FUNCTION public.main_getiosdevice(
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
	FROM Main_IOSDevices
	WHERE UserNo = main_getiosdevice.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
