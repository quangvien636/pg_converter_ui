-- ─── PROCEDURE→FUNCTION: note_updateiosdevice_timezoneoffset ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.note_updateiosdevice_timezoneoffset(integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.note_updateiosdevice_timezoneoffset(
    IN userno integer,
    IN deviceid character varying,
    IN timezoneoffset integer
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
