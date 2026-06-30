-- ─── FUNCTION: note_updateiosdevice_notificationoptions ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_updateiosdevice_notificationoptions(integer, character varying);
CREATE OR REPLACE FUNCTION public.note_updateiosdevice_notificationoptions(
    userno integer,
    deviceid character varying
) RETURNS void
AS $function$
BEGIN


	UPDATE Note_IOSDevices SET
		NotificationOptions = NotificationOptions
	WHERE UserNo = note_updateiosdevice_notificationoptions.userno AND DeviceID = note_updateiosdevice_notificationoptions.deviceid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
