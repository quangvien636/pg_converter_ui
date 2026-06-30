-- ─── FUNCTION: eapp_updateiosdevice_timezoneoffset ───────────────────────────────
DROP FUNCTION IF EXISTS public.eapp_updateiosdevice_timezoneoffset(integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.eapp_updateiosdevice_timezoneoffset(
    userno integer,
    deviceid character varying,
    timezoneoffset integer
) RETURNS void
AS $function$
BEGIN


	UPDATE EAPP_IOSDevices SET
		TimezoneOffset = eapp_updateiosdevice_timezoneoffset.timezoneoffset
	WHERE UserNo = eapp_updateiosdevice_timezoneoffset.userno AND DeviceID = eapp_updateiosdevice_timezoneoffset.deviceid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
