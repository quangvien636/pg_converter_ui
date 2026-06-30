-- ─── FUNCTION: schedule_updateresourceandroiddevice_timezoneoffset ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_updateresourceandroiddevice_timezoneoffset(integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.schedule_updateresourceandroiddevice_timezoneoffset(
    userno integer,
    deviceid character varying,
    timezoneoffset integer
) RETURNS void
AS $function$
BEGIN

	UPDATE ScheduleResourceAndroidDevices SET
		TimezoneOffset = schedule_updateresourceandroiddevice_timezoneoffset.timezoneoffset
	WHERE UserNo = schedule_updateresourceandroiddevice_timezoneoffset.userno AND DeviceID = schedule_updateresourceandroiddevice_timezoneoffset.deviceid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
