-- ─── FUNCTION: noticesyn_updateiosdevice_timezoneoffset ───────────────────────────────
DROP FUNCTION IF EXISTS public.noticesyn_updateiosdevice_timezoneoffset(integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.noticesyn_updateiosdevice_timezoneoffset(
    userno integer,
    deviceid character varying,
    timezoneoffset integer
) RETURNS void
AS $function$
BEGIN


	UPDATE NoticeSyn_IOSDevices SET
		TimezoneOffset = noticesyn_updateiosdevice_timezoneoffset.timezoneoffset
	WHERE UserNo = noticesyn_updateiosdevice_timezoneoffset.userno AND DeviceID = noticesyn_updateiosdevice_timezoneoffset.deviceid

END;
----------------------------------////////////////////------------------------------
-- USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
