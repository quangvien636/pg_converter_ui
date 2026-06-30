-- ─── PROCEDURE→FUNCTION: center_insertnotificationservice_alarmdetail ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.center_insertnotificationservice_alarmdetail(bigint, character varying, time without time zone, integer, character varying);
CREATE OR REPLACE FUNCTION public.center_insertnotificationservice_alarmdetail(
    IN notificationno bigint,
    IN alarmcode character varying,
    IN alarmstarttime time without time zone,
    IN alarm_time integer,
    IN title character varying
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
