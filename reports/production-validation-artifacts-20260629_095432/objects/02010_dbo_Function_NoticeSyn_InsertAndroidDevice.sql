-- ─── FUNCTION: noticesyn_insertandroiddevice ───────────────────────────────
DROP FUNCTION IF EXISTS public.noticesyn_insertandroiddevice(integer, timestamp without time zone, character varying, character varying, character varying, integer);
CREATE OR REPLACE FUNCTION public.noticesyn_insertandroiddevice(
    userno integer,
    regdate timestamp without time zone,
    deviceid character varying,
    osversion character varying,
    notificationoptions character varying,
    timezoneoffset integer
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    deviceno bigint;
BEGIN


	DELETE FROM NoticeSyn_AndroidDevices WHERE UserNo = noticesyn_insertandroiddevice.userno OR DeviceID = noticesyn_insertandroiddevice.deviceid

	INSERT INTO NoticeSyn_AndroidDevices (UserNo, RegDate, DeviceID, OSVersion, NotificationOptions, TimezoneOffset)
	VALUES (UserNo, RegDate, DeviceID, OSVersion, NotificationOptions, TimezoneOffset)


	SET DeviceNo = lastval()

	RETURN QUERY
	SELECT DeviceNo

END;
---------------------------- -----------------------------
-- USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
