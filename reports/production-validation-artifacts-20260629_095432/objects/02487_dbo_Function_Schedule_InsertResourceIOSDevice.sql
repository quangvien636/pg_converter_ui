-- ─── FUNCTION: schedule_insertresourceiosdevice ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_insertresourceiosdevice(integer, timestamp without time zone, character varying, character varying, character varying, integer);
CREATE OR REPLACE FUNCTION public.schedule_insertresourceiosdevice(
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

	DELETE FROM ScheduleResourceIOSDevices WHERE UserNo = schedule_insertresourceiosdevice.userno OR DeviceID = schedule_insertresourceiosdevice.deviceid;
	INSERT INTO ScheduleResourceIOSDevices (UserNo, RegDate, DeviceID, OSVersion, NotificationOptions, TimezoneOffset)
	VALUES (UserNo, RegDate, DeviceID, OSVersion, NotificationOptions, TimezoneOffset)


	SET DeviceNo = lastval()

	RETURN QUERY
	SELECT DeviceNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
