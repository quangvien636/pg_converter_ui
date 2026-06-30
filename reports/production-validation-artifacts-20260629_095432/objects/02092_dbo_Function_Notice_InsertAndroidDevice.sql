-- ─── FUNCTION: notice_insertandroiddevice ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_insertandroiddevice(integer, timestamp without time zone, character varying, character varying, character varying, integer);
CREATE OR REPLACE FUNCTION public.notice_insertandroiddevice(
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


	DELETE FROM Notice_AndroidDevices WHERE UserNo = notice_insertandroiddevice.userno OR DeviceID = notice_insertandroiddevice.deviceid

	INSERT INTO Notice_AndroidDevices (UserNo, RegDate, DeviceID, OSVersion, NotificationOptions, TimezoneOffset)
	VALUES (UserNo, RegDate, DeviceID, OSVersion, NotificationOptions, TimezoneOffset)


	SET DeviceNo = lastval()

	RETURN QUERY
	SELECT DeviceNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
