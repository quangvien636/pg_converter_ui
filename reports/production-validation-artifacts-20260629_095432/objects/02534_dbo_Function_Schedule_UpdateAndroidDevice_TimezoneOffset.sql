-- ─── FUNCTION: schedule_updateandroiddevice_timezoneoffset ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_updateandroiddevice_timezoneoffset(integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.schedule_updateandroiddevice_timezoneoffset(
    userno integer,
    deviceid character varying,
    timezoneoffset integer
) RETURNS void
AS $function$
BEGIN


	UPDATE Schedule_AndroidDevices SET
		TimezoneOffset = schedule_updateandroiddevice_timezoneoffset.timezoneoffset
	WHERE UserNo = schedule_updateandroiddevice_timezoneoffset.userno AND DeviceID = schedule_updateandroiddevice_timezoneoffset.deviceid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
