-- ─── FUNCTION: dday_insertandroiddevice ───────────────────────────────
DROP FUNCTION IF EXISTS public.dday_insertandroiddevice(integer, timestamp without time zone, character varying, character varying, character varying, integer);
CREATE OR REPLACE FUNCTION public.dday_insertandroiddevice(
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


	DELETE FROM DDay_AndroidDevices WHERE UserNo = dday_insertandroiddevice.userno OR DeviceID = dday_insertandroiddevice.deviceid

	INSERT INTO DDay_AndroidDevices VALUES (UserNo, RegDate, DeviceID, OSVersion, NotificationOptions, TimezoneOffset)


	SET DeviceNo = lastval()

	RETURN QUERY
	SELECT DeviceNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
