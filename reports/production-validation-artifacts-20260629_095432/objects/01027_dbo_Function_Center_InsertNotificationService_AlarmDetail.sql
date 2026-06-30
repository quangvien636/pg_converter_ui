-- ─── FUNCTION: center_insertnotificationservice_alarmdetail ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_insertnotificationservice_alarmdetail(bigint, character varying, time without time zone, integer, character varying);
CREATE OR REPLACE FUNCTION public.center_insertnotificationservice_alarmdetail(
    notificationno bigint,
    alarmcode character varying,
    alarmstarttime time without time zone,
    alarm_time integer,
    title character varying
) RETURNS void
AS $function$
BEGIN


	INSERT INTO Center_NotificationService_AlarmDetail(NotificationNo,AlarmCode,AlarmStartTime,Alarm_Time,
			Title,Content_Json)
	values(NotificationNo,AlarmCode,AlarmStartTime,Alarm_Time,
			Title,Content_Json);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
