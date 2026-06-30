-- ─── FUNCTION: eapp_updateiosdevice_notificationoptions ───────────────────────────────
DROP FUNCTION IF EXISTS public.eapp_updateiosdevice_notificationoptions(integer, character varying);
CREATE OR REPLACE FUNCTION public.eapp_updateiosdevice_notificationoptions(
    userno integer,
    deviceid character varying
) RETURNS void
AS $function$
BEGIN


	UPDATE EAPP_IOSDevices SET
		NotificationOptions = NotificationOptions
	WHERE UserNo = eapp_updateiosdevice_notificationoptions.userno AND DeviceID = eapp_updateiosdevice_notificationoptions.deviceid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
