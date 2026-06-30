-- ─── FUNCTION: schedule_addiosot ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_addiosot(integer, boolean, boolean, time without time zone);
CREATE OR REPLACE FUNCTION public.schedule_addiosot(
    p_deviceno integer,
    p_isalarm boolean,
    p_isalarmtime boolean,
    p_starttime time without time zone
) RETURNS void
AS $function$
BEGIN


	update Schedule_IOSDevices 
	set IsAlarm = schedule_addiosot.p_isalarm,
	IsAlarmTime =schedule_addiosot.p_isalarmtime,
	StartTime = schedule_addiosot.p_starttime,
	EndTime = p_EndTime
	WHERE DeviceNo = schedule_addiosot.p_deviceno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
