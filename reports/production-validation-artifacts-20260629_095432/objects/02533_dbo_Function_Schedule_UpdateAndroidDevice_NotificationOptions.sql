-- ─── FUNCTION: schedule_updateandroiddevice_notificationoptions ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_updateandroiddevice_notificationoptions(integer, character varying, character varying, boolean, boolean, time without time zone);
CREATE OR REPLACE FUNCTION public.schedule_updateandroiddevice_notificationoptions(
    userno integer,
    deviceid character varying,
    notificationoptions character varying,
    p_isalarm boolean,
    p_isalarmtime boolean,
    p_starttime time without time zone
) RETURNS void
AS $function$
BEGIN


	UPDATE Schedule_AndroidDevices SET
		NotificationOptions = schedule_updateandroiddevice_notificationoptions.notificationoptions,
		IsAlarm = schedule_updateandroiddevice_notificationoptions.p_isalarm,
		IsAlarmTime =schedule_updateandroiddevice_notificationoptions.p_isalarmtime,
		StartTime = schedule_updateandroiddevice_notificationoptions.p_starttime,
		EndTime = p_EndTime
	WHERE UserNo = schedule_updateandroiddevice_notificationoptions.userno AND DeviceID = schedule_updateandroiddevice_notificationoptions.deviceid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
