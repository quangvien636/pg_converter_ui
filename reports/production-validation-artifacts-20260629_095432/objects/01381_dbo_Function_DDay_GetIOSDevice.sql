-- ─── FUNCTION: dday_getiosdevice ───────────────────────────────
DROP FUNCTION IF EXISTS public.dday_getiosdevice(integer);
CREATE OR REPLACE FUNCTION public.dday_getiosdevice(
    userno integer
) RETURNS TABLE(
    deviceno text,
    regdate text,
    deviceid text,
    osversion text,
    notificationoptions text,
    timezoneoffset text,
    languagecode text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT DeviceNo, RegDate, DeviceID, OSVersion, NotificationOptions, TimezoneOffset, LanguageCode
	FROM DDay_IOSDevices
	WHERE UserNo = dday_getiosdevice.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
