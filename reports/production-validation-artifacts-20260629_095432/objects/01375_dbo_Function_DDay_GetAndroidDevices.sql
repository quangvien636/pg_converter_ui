-- ─── FUNCTION: dday_getandroiddevices ───────────────────────────────
DROP FUNCTION IF EXISTS public.dday_getandroiddevices();
CREATE OR REPLACE FUNCTION public.dday_getandroiddevices(
) RETURNS TABLE(
    deviceno text,
    userno text,
    regdate text,
    deviceid text,
    osversion text,
    notificationoptions text,
    col7 text
)
AS $function$
DECLARE
    query character varying;
BEGIN



	SET Query = 
		'SELECT DeviceNo, UserNo, RegDate, DeviceID, OSVersion, NotificationOptions, TimezoneOffset ' +
		'FROM DDay_AndroidDevices ' +
		'WHERE UserNo IN (' || ListOfUsers || ')'

	EXEC SP_EXECUTESQL Query;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
