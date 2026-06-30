-- ─── FUNCTION: noticesyn_updateandroiddevice_notificationoptions ───────────────────────────────
DROP FUNCTION IF EXISTS public.noticesyn_updateandroiddevice_notificationoptions(integer, character varying);
CREATE OR REPLACE FUNCTION public.noticesyn_updateandroiddevice_notificationoptions(
    userno integer,
    deviceid character varying
) RETURNS void
AS $function$
BEGIN


	UPDATE NoticeSyn_AndroidDevices SET
		NotificationOptions = NotificationOptions
	WHERE UserNo = noticesyn_updateandroiddevice_notificationoptions.userno AND DeviceID = noticesyn_updateandroiddevice_notificationoptions.deviceid

END;
-------------------------------- ////////////////
-- USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
