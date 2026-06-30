-- ─── FUNCTION: noticesyn_getandroiddevice ───────────────────────────────
DROP FUNCTION IF EXISTS public.noticesyn_getandroiddevice(integer);
CREATE OR REPLACE FUNCTION public.noticesyn_getandroiddevice(
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
	FROM NoticeSyn_AndroidDevices
	WHERE UserNo = noticesyn_getandroiddevice.userno
	
END;
-----------------------------------------------//////////////////////////////////---------------
--USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
