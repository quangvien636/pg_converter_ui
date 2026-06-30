-- ─── FUNCTION: mail_updateiosdevice_notificationoptions ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_updateiosdevice_notificationoptions(integer, character varying);
CREATE OR REPLACE FUNCTION public.mail_updateiosdevice_notificationoptions(
    userno integer,
    deviceid character varying
) RETURNS void
AS $function$
BEGIN


	UPDATE Mail_IOSDevices SET
		NotificationOptions = NotificationOptions
	WHERE UserNo = mail_updateiosdevice_notificationoptions.userno AND DeviceID = mail_updateiosdevice_notificationoptions.deviceid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
