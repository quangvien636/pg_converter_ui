-- ─── FUNCTION: notice_addiosot ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_addiosot(integer, boolean, boolean, time without time zone);
CREATE OR REPLACE FUNCTION public.notice_addiosot(
    p_deviceno integer,
    p_isalarm boolean,
    p_isalarmtime boolean,
    p_starttime time without time zone
) RETURNS void
AS $function$
BEGIN


	update Notice_IOSDevices 
	set IsAlarm = notice_addiosot.p_isalarm,
	IsAlarmTime =notice_addiosot.p_isalarmtime,
	StartTime = notice_addiosot.p_starttime,
	EndTime = p_EndTime
	WHERE DeviceNo = notice_addiosot.p_deviceno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
