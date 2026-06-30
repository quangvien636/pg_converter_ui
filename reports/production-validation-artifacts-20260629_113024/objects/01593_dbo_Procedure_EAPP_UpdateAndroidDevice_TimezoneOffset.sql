-- ─── PROCEDURE→FUNCTION: eapp_updateandroiddevice_timezoneoffset ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.eapp_updateandroiddevice_timezoneoffset(integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.eapp_updateandroiddevice_timezoneoffset(
    IN userno integer,
    IN deviceid character varying,
    IN timezoneoffset integer
) RETURNS void
AS $function$
BEGIN


	UPDATE EAPP_AndroidDevices SET
		TimezoneOffset = eapp_updateandroiddevice_timezoneoffset.timezoneoffset
	WHERE UserNo = eapp_updateandroiddevice_timezoneoffset.userno AND DeviceID = eapp_updateandroiddevice_timezoneoffset.deviceid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
