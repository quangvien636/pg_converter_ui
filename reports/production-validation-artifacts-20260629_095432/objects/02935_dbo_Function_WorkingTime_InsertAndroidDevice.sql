-- ─── FUNCTION: workingtime_insertandroiddevice ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_insertandroiddevice(integer, timestamp without time zone, character varying, character varying, character varying, integer);
CREATE OR REPLACE FUNCTION public.workingtime_insertandroiddevice(
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


	DELETE FROM WorkingTime_AndroidDevices WHERE UserNo = workingtime_insertandroiddevice.userno OR DeviceID = workingtime_insertandroiddevice.deviceid

	INSERT INTO WorkingTime_AndroidDevices VALUES (UserNo, RegDate, DeviceID, OSVersion, NotificationOptions, TimezoneOffset, LanguageCode)


	SET DeviceNo = lastval()

	RETURN QUERY
	SELECT DeviceNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
