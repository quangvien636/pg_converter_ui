-- ─── FUNCTION: eapp_getandroiddevice ───────────────────────────────
DROP FUNCTION IF EXISTS public.eapp_getandroiddevice(integer);
CREATE OR REPLACE FUNCTION public.eapp_getandroiddevice(
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
	FROM EAPP_AndroidDevices
	WHERE UserNo = eapp_getandroiddevice.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
