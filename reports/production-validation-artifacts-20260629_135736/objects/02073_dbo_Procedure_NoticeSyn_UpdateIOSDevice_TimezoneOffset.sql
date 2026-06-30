-- ─── PROCEDURE→FUNCTION: noticesyn_updateiosdevice_timezoneoffset ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.noticesyn_updateiosdevice_timezoneoffset(integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.noticesyn_updateiosdevice_timezoneoffset(
    IN userno integer,
    IN deviceid character varying,
    IN timezoneoffset integer
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
