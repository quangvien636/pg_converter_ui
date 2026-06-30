-- ─── FUNCTION: schedule_addandroidot ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_addandroidot(integer, boolean, boolean, time without time zone);
CREATE OR REPLACE FUNCTION public.schedule_addandroidot(
    p_deviceno integer,
    p_isalarm boolean,
    p_isalarmtime boolean,
    p_starttime time without time zone
) RETURNS void
AS $function$
BEGIN


	update Schedule_AndroidDevices 
	set IsAlarm = schedule_addandroidot.p_isalarm,
	IsAlarmTime =schedule_addandroidot.p_isalarmtime,
	StartTime = schedule_addandroidot.p_starttime,
	EndTime = p_EndTime
	WHERE DeviceNo = schedule_addandroidot.p_deviceno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
