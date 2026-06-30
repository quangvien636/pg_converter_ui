-- ─── FUNCTION: noticesyn_getiosdeviceofallusers ───────────────────────────────
DROP FUNCTION IF EXISTS public.noticesyn_getiosdeviceofallusers();
CREATE OR REPLACE FUNCTION public.noticesyn_getiosdeviceofallusers(
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
	INNER JOIN NoticeSyn_IOSDevices A ON A.UserNO = U.UserNo
	WHERE U.Enabled = TRUE
	
END;
------------------------/////////////////////////////// ----------------------------
--- USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
