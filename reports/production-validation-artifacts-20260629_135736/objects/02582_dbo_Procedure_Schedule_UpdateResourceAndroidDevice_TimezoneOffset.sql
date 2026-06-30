-- ─── PROCEDURE→FUNCTION: schedule_updateresourceandroiddevice_timezoneoffset ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_updateresourceandroiddevice_timezoneoffset(integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.schedule_updateresourceandroiddevice_timezoneoffset(
    IN userno integer,
    IN deviceid character varying,
    IN timezoneoffset integer
) RETURNS void
AS $function$
BEGIN

	UPDATE ScheduleResourceAndroidDevices SET
		TimezoneOffset = schedule_updateresourceandroiddevice_timezoneoffset.timezoneoffset
	WHERE UserNo = schedule_updateresourceandroiddevice_timezoneoffset.userno AND DeviceID = schedule_updateresourceandroiddevice_timezoneoffset.deviceid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
