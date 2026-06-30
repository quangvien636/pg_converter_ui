-- ─── FUNCTION: workingtime_updateandroiddevice_timezoneoffset ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_updateandroiddevice_timezoneoffset(integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.workingtime_updateandroiddevice_timezoneoffset(
    userno integer,
    deviceid character varying,
    timezoneoffset integer
) RETURNS void
AS $function$
BEGIN


	UPDATE WorkingTime_AndroidDevices SET
		TimezoneOffset = workingtime_updateandroiddevice_timezoneoffset.timezoneoffset
	WHERE UserNo = workingtime_updateandroiddevice_timezoneoffset.userno AND DeviceID = workingtime_updateandroiddevice_timezoneoffset.deviceid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
