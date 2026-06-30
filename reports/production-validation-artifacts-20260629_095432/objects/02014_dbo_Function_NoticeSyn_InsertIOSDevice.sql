-- ─── FUNCTION: noticesyn_insertiosdevice ───────────────────────────────
DROP FUNCTION IF EXISTS public.noticesyn_insertiosdevice(integer, timestamp without time zone, character varying, character varying, character varying, integer);
CREATE OR REPLACE FUNCTION public.noticesyn_insertiosdevice(
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


	DELETE FROM NoticeSyn_IOSDevices WHERE UserNo = noticesyn_insertiosdevice.userno OR DeviceID = noticesyn_insertiosdevice.deviceid;
	INSERT INTO NoticeSyn_IOSDevices (UserNo, RegDate, DeviceID, OSVersion, NotificationOptions, TimezoneOffset)
	VALUES (UserNo, RegDate, DeviceID, OSVersion, NotificationOptions, TimezoneOffset)


	SET DeviceNo = lastval()

	RETURN QUERY
	SELECT DeviceNo

END;
---------------------- -----------------------------------
-- USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
