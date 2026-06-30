-- ─── FUNCTION: board_getandroiddeviceofallusers ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_getandroiddeviceofallusers();
CREATE OR REPLACE FUNCTION public.board_getandroiddeviceofallusers(
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
	INNER JOIN Board_AndroidDevices A ON A.UserNO = U.UserNo
	WHERE U.Enabled = TRUE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
