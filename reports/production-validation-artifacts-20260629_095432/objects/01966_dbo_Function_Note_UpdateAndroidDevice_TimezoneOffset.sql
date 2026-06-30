-- ─── FUNCTION: note_updateandroiddevice_timezoneoffset ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_updateandroiddevice_timezoneoffset(integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.note_updateandroiddevice_timezoneoffset(
    userno integer,
    deviceid character varying,
    timezoneoffset integer
) RETURNS void
AS $function$
BEGIN


	UPDATE Note_AndroidDevices SET
		TimezoneOffset = note_updateandroiddevice_timezoneoffset.timezoneoffset
	WHERE UserNo = note_updateandroiddevice_timezoneoffset.userno AND DeviceID = note_updateandroiddevice_timezoneoffset.deviceid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
