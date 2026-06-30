-- ─── FUNCTION: notice_updateiosdevice_notificationoptions ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_updateiosdevice_notificationoptions(integer, character varying, character varying, boolean, boolean, time without time zone);
CREATE OR REPLACE FUNCTION public.notice_updateiosdevice_notificationoptions(
    userno integer,
    deviceid character varying,
    notificationoptions character varying,
    p_isalarm boolean,
    p_isalarmtime boolean,
    p_starttime time without time zone
) RETURNS void
AS $function$
BEGIN


	UPDATE Notice_IOSDevices SET
		NotificationOptions = notice_updateiosdevice_notificationoptions.notificationoptions,
		IsAlarm = notice_updateiosdevice_notificationoptions.p_isalarm,
		IsAlarmTime =notice_updateiosdevice_notificationoptions.p_isalarmtime,
		StartTime = notice_updateiosdevice_notificationoptions.p_starttime,
		EndTime = p_EndTime
	WHERE UserNo = notice_updateiosdevice_notificationoptions.userno AND DeviceID = notice_updateiosdevice_notificationoptions.deviceid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
