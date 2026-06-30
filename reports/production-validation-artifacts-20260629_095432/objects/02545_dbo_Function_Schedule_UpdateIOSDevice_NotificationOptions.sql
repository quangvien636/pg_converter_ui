-- ─── FUNCTION: schedule_updateiosdevice_notificationoptions ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_updateiosdevice_notificationoptions(integer, character varying, character varying, boolean, boolean, time without time zone);
CREATE OR REPLACE FUNCTION public.schedule_updateiosdevice_notificationoptions(
    userno integer,
    deviceid character varying,
    notificationoptions character varying,
    p_isalarm boolean,
    p_isalarmtime boolean,
    p_starttime time without time zone
) RETURNS void
AS $function$
BEGIN


	UPDATE Schedule_IOSDevices SET
		NotificationOptions = schedule_updateiosdevice_notificationoptions.notificationoptions,
		IsAlarm = schedule_updateiosdevice_notificationoptions.p_isalarm,
		IsAlarmTime =schedule_updateiosdevice_notificationoptions.p_isalarmtime,
		StartTime = schedule_updateiosdevice_notificationoptions.p_starttime,
		EndTime = p_EndTime
	WHERE UserNo = schedule_updateiosdevice_notificationoptions.userno AND DeviceID = schedule_updateiosdevice_notificationoptions.deviceid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
