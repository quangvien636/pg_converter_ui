-- ─── FUNCTION: notice_updateandroiddevice_notificationoptions ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_updateandroiddevice_notificationoptions(integer, character varying, character varying, boolean, boolean, time without time zone);
CREATE OR REPLACE FUNCTION public.notice_updateandroiddevice_notificationoptions(
    userno integer,
    deviceid character varying,
    notificationoptions character varying,
    p_isalarm boolean,
    p_isalarmtime boolean,
    p_starttime time without time zone
) RETURNS void
AS $function$
BEGIN


	UPDATE Notice_AndroidDevices SET
		NotificationOptions = notice_updateandroiddevice_notificationoptions.notificationoptions,
		IsAlarm = notice_updateandroiddevice_notificationoptions.p_isalarm,
		IsAlarmTime =notice_updateandroiddevice_notificationoptions.p_isalarmtime,
		StartTime = notice_updateandroiddevice_notificationoptions.p_starttime,
		EndTime = p_EndTime
	WHERE UserNo = notice_updateandroiddevice_notificationoptions.userno AND DeviceID = notice_updateandroiddevice_notificationoptions.deviceid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
