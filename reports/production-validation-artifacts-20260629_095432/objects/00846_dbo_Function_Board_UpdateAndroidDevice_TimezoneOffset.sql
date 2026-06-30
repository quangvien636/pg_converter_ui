-- ─── FUNCTION: board_updateandroiddevice_timezoneoffset ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_updateandroiddevice_timezoneoffset(integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.board_updateandroiddevice_timezoneoffset(
    userno integer,
    deviceid character varying,
    timezoneoffset integer
) RETURNS void
AS $function$
BEGIN


	UPDATE Board_AndroidDevices SET
		TimezoneOffset = board_updateandroiddevice_timezoneoffset.timezoneoffset
	WHERE UserNo = board_updateandroiddevice_timezoneoffset.userno AND DeviceID = board_updateandroiddevice_timezoneoffset.deviceid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
