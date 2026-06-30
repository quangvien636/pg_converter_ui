-- ─── FUNCTION: schedule_updateresourceiosdevice_notificationoptions ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_updateresourceiosdevice_notificationoptions(integer, character varying);
CREATE OR REPLACE FUNCTION public.schedule_updateresourceiosdevice_notificationoptions(
    userno integer,
    deviceid character varying
) RETURNS void
AS $function$
BEGIN

	UPDATE ScheduleResourceIOSDevices SET
		NotificationOptions = NotificationOptions
	WHERE UserNo = schedule_updateresourceiosdevice_notificationoptions.userno AND DeviceID = schedule_updateresourceiosdevice_notificationoptions.deviceid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
