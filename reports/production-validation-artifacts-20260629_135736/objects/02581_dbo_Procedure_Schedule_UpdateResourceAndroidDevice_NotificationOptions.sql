-- ─── PROCEDURE→FUNCTION: schedule_updateresourceandroiddevice_notificationoptions ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_updateresourceandroiddevice_notificationoptions(integer, character varying);
CREATE OR REPLACE FUNCTION public.schedule_updateresourceandroiddevice_notificationoptions(
    IN userno integer,
    IN deviceid character varying
) RETURNS void
AS $function$
BEGIN


	UPDATE ScheduleResourceAndroidDevices SET
		NotificationOptions = NotificationOptions
	WHERE UserNo = schedule_updateresourceandroiddevice_notificationoptions.userno AND DeviceID = schedule_updateresourceandroiddevice_notificationoptions.deviceid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
