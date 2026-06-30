-- ─── PROCEDURE→FUNCTION: notice_updateiosdevice_timezoneoffset ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.notice_updateiosdevice_timezoneoffset(integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.notice_updateiosdevice_timezoneoffset(
    IN userno integer,
    IN deviceid character varying,
    IN timezoneoffset integer
) RETURNS void
AS $function$
BEGIN


	UPDATE Notice_IOSDevices SET
		TimezoneOffset = notice_updateiosdevice_timezoneoffset.timezoneoffset
	WHERE UserNo = notice_updateiosdevice_timezoneoffset.userno AND DeviceID = notice_updateiosdevice_timezoneoffset.deviceid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
