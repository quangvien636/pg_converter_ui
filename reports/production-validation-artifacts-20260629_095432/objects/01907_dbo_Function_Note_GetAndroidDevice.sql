-- ─── FUNCTION: note_getandroiddevice ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_getandroiddevice(integer);
CREATE OR REPLACE FUNCTION public.note_getandroiddevice(
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
	FROM Note_AndroidDevices
	WHERE UserNo = note_getandroiddevice.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
