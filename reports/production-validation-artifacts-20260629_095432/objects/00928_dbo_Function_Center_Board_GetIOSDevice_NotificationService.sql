-- ─── FUNCTION: center_board_getiosdevice_notificationservice ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_board_getiosdevice_notificationservice(integer);
CREATE OR REPLACE FUNCTION public.center_board_getiosdevice_notificationservice(
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
	FROM Board_IOSDevices
	WHERE UserNo = center_board_getiosdevice_notificationservice.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
