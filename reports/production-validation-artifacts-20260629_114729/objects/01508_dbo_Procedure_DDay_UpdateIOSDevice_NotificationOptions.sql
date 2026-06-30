-- ─── PROCEDURE→FUNCTION: dday_updateiosdevice_notificationoptions ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.dday_updateiosdevice_notificationoptions(integer, character varying);
CREATE OR REPLACE FUNCTION public.dday_updateiosdevice_notificationoptions(
    IN userno integer,
    IN deviceid character varying
) RETURNS void
AS $function$
BEGIN


	UPDATE DDay_IOSDevices SET
		NotificationOptions = NotificationOptions
	WHERE UserNo = dday_updateiosdevice_notificationoptions.userno AND DeviceID = dday_updateiosdevice_notificationoptions.deviceid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
