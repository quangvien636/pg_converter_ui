-- ─── FUNCTION: workingtime_updateiosdevice_timezoneoffset ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_updateiosdevice_timezoneoffset(integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.workingtime_updateiosdevice_timezoneoffset(
    userno integer,
    deviceid character varying,
    timezoneoffset integer
) RETURNS void
AS $function$
BEGIN


	UPDATE WorkingTime_IOSDevices SET
		TimezoneOffset = workingtime_updateiosdevice_timezoneoffset.timezoneoffset
	WHERE UserNo = workingtime_updateiosdevice_timezoneoffset.userno AND DeviceID = workingtime_updateiosdevice_timezoneoffset.deviceid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
