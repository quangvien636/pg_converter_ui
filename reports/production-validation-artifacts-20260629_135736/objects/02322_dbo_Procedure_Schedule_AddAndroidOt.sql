-- ─── PROCEDURE→FUNCTION: schedule_addandroidot ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_addandroidot(integer, boolean, boolean, time without time zone);
CREATE OR REPLACE FUNCTION public.schedule_addandroidot(
    IN p_deviceno integer,
    IN p_isalarm boolean,
    IN p_isalarmtime boolean,
    IN p_starttime time without time zone
) RETURNS void
AS $function$
BEGIN


	update Schedule_AndroidDevices 
	IsAlarm := schedule_addandroidot.p_isalarm,;
	IsAlarmTime =schedule_addandroidot.p_isalarmtime,
	StartTime = schedule_addandroidot.p_starttime,
	EndTime = p_EndTime
	WHERE DeviceNo = schedule_addandroidot.p_deviceno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
