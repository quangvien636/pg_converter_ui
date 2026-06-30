-- ─── FUNCTION: notice_addandroidot ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_addandroidot(integer, boolean, boolean, time without time zone);
CREATE OR REPLACE FUNCTION public.notice_addandroidot(
    p_deviceno integer,
    p_isalarm boolean,
    p_isalarmtime boolean,
    p_starttime time without time zone
) RETURNS void
AS $function$
BEGIN


	update Notice_AndroidDevices 
	set IsAlarm = notice_addandroidot.p_isalarm,
	IsAlarmTime =notice_addandroidot.p_isalarmtime,
	StartTime = notice_addandroidot.p_starttime,
	EndTime = p_EndTime
	WHERE DeviceNo = notice_addandroidot.p_deviceno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
