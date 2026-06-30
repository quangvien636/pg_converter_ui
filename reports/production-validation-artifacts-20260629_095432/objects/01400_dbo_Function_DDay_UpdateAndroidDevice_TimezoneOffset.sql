-- ─── FUNCTION: dday_updateandroiddevice_timezoneoffset ───────────────────────────────
DROP FUNCTION IF EXISTS public.dday_updateandroiddevice_timezoneoffset(integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.dday_updateandroiddevice_timezoneoffset(
    userno integer,
    deviceid character varying,
    timezoneoffset integer
) RETURNS void
AS $function$
BEGIN


	UPDATE DDay_AndroidDevices SET
		TimezoneOffset = dday_updateandroiddevice_timezoneoffset.timezoneoffset
	WHERE UserNo = dday_updateandroiddevice_timezoneoffset.userno AND DeviceID = dday_updateandroiddevice_timezoneoffset.deviceid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
