-- ─── FUNCTION: workingtime_insertiosdevice ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_insertiosdevice(integer, timestamp without time zone, character varying, character varying, character varying, integer);
CREATE OR REPLACE FUNCTION public.workingtime_insertiosdevice(
    userno integer,
    regdate timestamp without time zone,
    deviceid character varying,
    osversion character varying,
    notificationoptions character varying,
    timezoneoffset integer
) RETURNS TABLE(
    deviceno text
)
AS $function$
DECLARE
    deviceno bigint;
BEGIN


	DELETE FROM WorkingTime_IOSDevices WHERE UserNo = workingtime_insertiosdevice.userno OR DeviceID = workingtime_insertiosdevice.deviceid

	INSERT INTO WorkingTime_IOSDevices (UserNo, RegDate, DeviceID, OSVersion, NotificationOptions, TimezoneOffset, LanguageCode)
	VALUES (UserNo, RegDate, DeviceID, OSVersion, NotificationOptions, TimezoneOffset, LanguageCode)


	SET DeviceNo = lastval()

	RETURN QUERY
	SELECT DeviceNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
