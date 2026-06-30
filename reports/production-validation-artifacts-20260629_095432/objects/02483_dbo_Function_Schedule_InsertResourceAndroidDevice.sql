-- ─── FUNCTION: schedule_insertresourceandroiddevice ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_insertresourceandroiddevice(integer, timestamp without time zone, character varying, character varying, character varying, integer);
CREATE OR REPLACE FUNCTION public.schedule_insertresourceandroiddevice(
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

	DELETE FROM ScheduleResourceAndroidDevices WHERE UserNo = schedule_insertresourceandroiddevice.userno OR DeviceID = schedule_insertresourceandroiddevice.deviceid;
	INSERT INTO ScheduleResourceAndroidDevices VALUES (UserNo, RegDate, DeviceID, OSVersion, NotificationOptions, TimezoneOffset)

	SET DeviceNo = lastval()
	RETURN QUERY
	SELECT DeviceNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
