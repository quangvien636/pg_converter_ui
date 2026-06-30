-- ─── FUNCTION: note_updateiosdevice_timezoneoffset ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_updateiosdevice_timezoneoffset(integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.note_updateiosdevice_timezoneoffset(
    userno integer,
    deviceid character varying,
    timezoneoffset integer
) RETURNS void
AS $function$
BEGIN


	UPDATE Note_IOSDevices SET
		TimezoneOffset = note_updateiosdevice_timezoneoffset.timezoneoffset
	WHERE UserNo = note_updateiosdevice_timezoneoffset.userno AND DeviceID = note_updateiosdevice_timezoneoffset.deviceid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
