-- ─── FUNCTION: notice_updateandroiddevice_timezoneoffset ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_updateandroiddevice_timezoneoffset(integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.notice_updateandroiddevice_timezoneoffset(
    userno integer,
    deviceid character varying,
    timezoneoffset integer
) RETURNS void
AS $function$
BEGIN


	UPDATE Notice_AndroidDevices SET
		TimezoneOffset = notice_updateandroiddevice_timezoneoffset.timezoneoffset
	WHERE UserNo = notice_updateandroiddevice_timezoneoffset.userno AND DeviceID = notice_updateandroiddevice_timezoneoffset.deviceid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
