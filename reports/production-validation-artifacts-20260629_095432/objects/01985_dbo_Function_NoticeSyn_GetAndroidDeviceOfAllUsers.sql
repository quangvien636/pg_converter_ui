-- ─── FUNCTION: noticesyn_getandroiddeviceofallusers ───────────────────────────────
DROP FUNCTION IF EXISTS public.noticesyn_getandroiddeviceofallusers();
CREATE OR REPLACE FUNCTION public.noticesyn_getandroiddeviceofallusers(
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
	INNER JOIN NoticeSyn_AndroidDevices A ON A.UserNO = U.UserNo
	WHERE U.Enabled = TRUE
	
END;
---------------------------////////////////////////////////////////////----------
-- USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
