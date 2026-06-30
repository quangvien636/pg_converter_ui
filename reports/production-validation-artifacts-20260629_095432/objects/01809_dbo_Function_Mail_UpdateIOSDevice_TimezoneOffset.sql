-- ─── FUNCTION: mail_updateiosdevice_timezoneoffset ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_updateiosdevice_timezoneoffset(integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.mail_updateiosdevice_timezoneoffset(
    userno integer,
    deviceid character varying,
    timezoneoffset integer
) RETURNS void
AS $function$
BEGIN


	UPDATE Mail_IOSDevices SET
		TimezoneOffset = mail_updateiosdevice_timezoneoffset.timezoneoffset
	WHERE UserNo = mail_updateiosdevice_timezoneoffset.userno AND DeviceID = mail_updateiosdevice_timezoneoffset.deviceid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
