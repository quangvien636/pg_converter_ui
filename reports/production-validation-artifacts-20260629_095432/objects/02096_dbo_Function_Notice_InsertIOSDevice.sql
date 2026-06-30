-- ─── FUNCTION: notice_insertiosdevice ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_insertiosdevice(integer, timestamp without time zone, character varying, character varying, character varying, integer);
CREATE OR REPLACE FUNCTION public.notice_insertiosdevice(
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


	DELETE FROM Notice_IOSDevices WHERE UserNo = notice_insertiosdevice.userno OR DeviceID = notice_insertiosdevice.deviceid;
	INSERT INTO Notice_IOSDevices (UserNo, RegDate, DeviceID, OSVersion, NotificationOptions, TimezoneOffset)
	VALUES (UserNo, RegDate, DeviceID, OSVersion, NotificationOptions, TimezoneOffset)


	SET DeviceNo = lastval()

	RETURN QUERY
	SELECT DeviceNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
