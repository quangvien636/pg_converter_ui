-- ─── FUNCTION: noticesyn_updateandroiddevice_timezoneoffset ───────────────────────────────
DROP FUNCTION IF EXISTS public.noticesyn_updateandroiddevice_timezoneoffset(integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.noticesyn_updateandroiddevice_timezoneoffset(
    userno integer,
    deviceid character varying,
    timezoneoffset integer
) RETURNS void
AS $function$
BEGIN


	UPDATE NoticeSyn_AndroidDevices SET
		TimezoneOffset = noticesyn_updateandroiddevice_timezoneoffset.timezoneoffset
	WHERE UserNo = noticesyn_updateandroiddevice_timezoneoffset.userno AND DeviceID = noticesyn_updateandroiddevice_timezoneoffset.deviceid

END;
------------------///////------------------
-- USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
