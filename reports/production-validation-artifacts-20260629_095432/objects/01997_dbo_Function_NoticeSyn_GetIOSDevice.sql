-- ─── FUNCTION: noticesyn_getiosdevice ───────────────────────────────
DROP FUNCTION IF EXISTS public.noticesyn_getiosdevice(integer);
CREATE OR REPLACE FUNCTION public.noticesyn_getiosdevice(
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
	FROM NoticeSyn_IOSDevices
	WHERE UserNo = noticesyn_getiosdevice.userno
	
END;
-------------------------------//////////////////////////////////// -----------------------
-- USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
