-- ─── PROCEDURE→FUNCTION: notice_addiosot ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.notice_addiosot(integer, boolean, boolean, time without time zone);
CREATE OR REPLACE FUNCTION public.notice_addiosot(
    IN p_deviceno integer,
    IN p_isalarm boolean,
    IN p_isalarmtime boolean,
    IN p_starttime time without time zone
) RETURNS void
AS $function$
BEGIN


	update Notice_IOSDevices 
	IsAlarm := notice_addiosot.p_isalarm,;
	IsAlarmTime =notice_addiosot.p_isalarmtime,
	StartTime = notice_addiosot.p_starttime,
	EndTime = p_EndTime
	WHERE DeviceNo = notice_addiosot.p_deviceno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
