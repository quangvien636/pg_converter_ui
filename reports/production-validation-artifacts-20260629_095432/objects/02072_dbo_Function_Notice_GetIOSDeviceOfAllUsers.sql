-- ─── FUNCTION: notice_getiosdeviceofallusers ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_getiosdeviceofallusers();
CREATE OR REPLACE FUNCTION public.notice_getiosdeviceofallusers(
) RETURNS TABLE(
    deviceid text,
    osversion text,
    notificationoptions text,
    timezoneoffset text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT DeviceID, OSVersion, NotificationOptions, TimezoneOffset
	FROM Organization_Users U
	INNER JOIN Notice_IOSDevices A ON A.UserNO = U.UserNo
	WHERE U.Enabled = TRUE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
