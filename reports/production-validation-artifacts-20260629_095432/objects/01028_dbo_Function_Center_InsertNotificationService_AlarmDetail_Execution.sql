-- ─── FUNCTION: center_insertnotificationservice_alarmdetail_execution ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_insertnotificationservice_alarmdetail_execution(bigint, bigint, timestamp without time zone, date);
CREATE OR REPLACE FUNCTION public.center_insertnotificationservice_alarmdetail_execution(
    notificationno bigint,
    notificationservice_alarmdetailno bigint,
    regdate timestamp without time zone,
    executiondate date
) RETURNS void
AS $function$
BEGIN


	INSERT INTO Center_NotificationService_AlarmDetail_Execution
	(NotificationNo,NotificationService_AlarmDetailNo,RegDate,ExecutionDate)
	values(NotificationNo,NotificationService_AlarmDetailNo,RegDate,ExecutionDate);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
