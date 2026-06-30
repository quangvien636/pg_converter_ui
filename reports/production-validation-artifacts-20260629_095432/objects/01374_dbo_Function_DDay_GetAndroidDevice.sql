-- ─── FUNCTION: dday_getandroiddevice ───────────────────────────────
DROP FUNCTION IF EXISTS public.dday_getandroiddevice(integer);
CREATE OR REPLACE FUNCTION public.dday_getandroiddevice(
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
	FROM DDay_AndroidDevices
	WHERE UserNo = dday_getandroiddevice.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
