-- ─── FUNCTION: eapp_updateandroiddevice_notificationoptions ───────────────────────────────
DROP FUNCTION IF EXISTS public.eapp_updateandroiddevice_notificationoptions(integer, character varying);
CREATE OR REPLACE FUNCTION public.eapp_updateandroiddevice_notificationoptions(
    userno integer,
    deviceid character varying
) RETURNS void
AS $function$
BEGIN


	UPDATE EAPP_AndroidDevices SET
		NotificationOptions = NotificationOptions
	WHERE UserNo = eapp_updateandroiddevice_notificationoptions.userno AND DeviceID = eapp_updateandroiddevice_notificationoptions.deviceid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
