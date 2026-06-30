-- ─── PROCEDURE→FUNCTION: schedule_updateiosdevice_notificationoptions ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_updateiosdevice_notificationoptions(integer, character varying, character varying, boolean, boolean, time without time zone);
CREATE OR REPLACE FUNCTION public.schedule_updateiosdevice_notificationoptions(
    IN userno integer,
    IN deviceid character varying,
    IN notificationoptions character varying,
    IN p_isalarm boolean,
    IN p_isalarmtime boolean,
    IN p_starttime time without time zone
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
