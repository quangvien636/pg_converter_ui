-- ─── PROCEDURE→FUNCTION: schedule_updateandroiddevice_timezoneoffset ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_updateandroiddevice_timezoneoffset(integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.schedule_updateandroiddevice_timezoneoffset(
    IN userno integer,
    IN deviceid character varying,
    IN timezoneoffset integer
) RETURNS void
AS $function$
BEGIN


	UPDATE Schedule_AndroidDevices SET
		TimezoneOffset = schedule_updateandroiddevice_timezoneoffset.timezoneoffset
	WHERE UserNo = schedule_updateandroiddevice_timezoneoffset.userno AND DeviceID = schedule_updateandroiddevice_timezoneoffset.deviceid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
