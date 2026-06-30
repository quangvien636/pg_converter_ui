-- ─── FUNCTION: workingtime_updateandroiddevice_notificationoptions ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_updateandroiddevice_notificationoptions(integer, character varying);
CREATE OR REPLACE FUNCTION public.workingtime_updateandroiddevice_notificationoptions(
    userno integer,
    deviceid character varying
) RETURNS void
AS $function$
BEGIN


	UPDATE WorkingTime_AndroidDevices SET
		NotificationOptions = NotificationOptions
	WHERE UserNo = workingtime_updateandroiddevice_notificationoptions.userno AND DeviceID = workingtime_updateandroiddevice_notificationoptions.deviceid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
