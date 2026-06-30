-- ─── FUNCTION: board_updateiosdevice_notificationoptions ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_updateiosdevice_notificationoptions(integer, character varying);
CREATE OR REPLACE FUNCTION public.board_updateiosdevice_notificationoptions(
    userno integer,
    deviceid character varying
) RETURNS void
AS $function$
BEGIN


	UPDATE Board_IOSDevices SET
		NotificationOptions = NotificationOptions
	WHERE UserNo = board_updateiosdevice_notificationoptions.userno AND DeviceID = board_updateiosdevice_notificationoptions.deviceid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
