-- ─── FUNCTION: dday_getiosdevices ───────────────────────────────
DROP FUNCTION IF EXISTS public.dday_getiosdevices();
CREATE OR REPLACE FUNCTION public.dday_getiosdevices(
) RETURNS TABLE(
    deviceno text,
    userno text,
    regdate text,
    deviceid text,
    osversion text,
    notificationoptions text,
    timezoneoffset text,
    col8 text
)
AS $function$
DECLARE
    query character varying;
BEGIN



	SET Query = 
		'SELECT DeviceNo, UserNo, RegDate, DeviceID, OSVersion, NotificationOptions, TimezoneOffset, LanguageCode ' +
		'FROM DDay_IOSDevices ' +
		'WHERE UserNo IN (' || ListOfUsers || ')'

	EXEC SP_EXECUTESQL Query;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
