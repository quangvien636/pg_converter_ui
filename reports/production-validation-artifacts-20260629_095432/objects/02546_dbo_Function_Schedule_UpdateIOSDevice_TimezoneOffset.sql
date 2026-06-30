-- ─── FUNCTION: schedule_updateiosdevice_timezoneoffset ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_updateiosdevice_timezoneoffset(integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.schedule_updateiosdevice_timezoneoffset(
    userno integer,
    deviceid character varying,
    timezoneoffset integer
) RETURNS void
AS $function$
BEGIN


	UPDATE Schedule_IOSDevices SET
		TimezoneOffset = schedule_updateiosdevice_timezoneoffset.timezoneoffset
	WHERE UserNo = schedule_updateiosdevice_timezoneoffset.userno AND DeviceID = schedule_updateiosdevice_timezoneoffset.deviceid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
