-- ─── FUNCTION: dday_updateiosdevice_timezoneoffset ───────────────────────────────
DROP FUNCTION IF EXISTS public.dday_updateiosdevice_timezoneoffset(integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.dday_updateiosdevice_timezoneoffset(
    userno integer,
    deviceid character varying,
    timezoneoffset integer
) RETURNS void
AS $function$
BEGIN


	UPDATE DDay_IOSDevices SET
		TimezoneOffset = dday_updateiosdevice_timezoneoffset.timezoneoffset
	WHERE UserNo = dday_updateiosdevice_timezoneoffset.userno AND DeviceID = dday_updateiosdevice_timezoneoffset.deviceid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
