-- ─── PROCEDURE→FUNCTION: notice_updateiosdevice_notificationoptions ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.notice_updateiosdevice_notificationoptions(integer, character varying, character varying, boolean, boolean, time without time zone);
CREATE OR REPLACE FUNCTION public.notice_updateiosdevice_notificationoptions(
    IN userno integer,
    IN deviceid character varying,
    IN notificationoptions character varying,
    IN p_isalarm boolean,
    IN p_isalarmtime boolean,
    IN p_starttime time without time zone
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
