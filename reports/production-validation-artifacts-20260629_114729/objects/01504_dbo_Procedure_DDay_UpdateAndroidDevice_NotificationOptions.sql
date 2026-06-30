-- ─── PROCEDURE→FUNCTION: dday_updateandroiddevice_notificationoptions ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.dday_updateandroiddevice_notificationoptions(integer, character varying);
CREATE OR REPLACE FUNCTION public.dday_updateandroiddevice_notificationoptions(
    IN userno integer,
    IN deviceid character varying
) RETURNS void
AS $function$
BEGIN


	UPDATE DDay_AndroidDevices SET
		NotificationOptions = NotificationOptions
	WHERE UserNo = dday_updateandroiddevice_notificationoptions.userno AND DeviceID = dday_updateandroiddevice_notificationoptions.deviceid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
