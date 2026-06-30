-- ─── FUNCTION: workingtime_getandroiddevices ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getandroiddevices();
CREATE OR REPLACE FUNCTION public.workingtime_getandroiddevices(
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
		'FROM WorkingTime_AndroidDevices  ' +
		'WHERE UserNo IN (' || ListOfUsers || ')'

	EXEC SP_EXECUTESQL Query;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
