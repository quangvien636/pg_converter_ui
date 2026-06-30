-- ─── PROCEDURE→FUNCTION: center_insertnotificationservice_alarmdetail_execution ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.center_insertnotificationservice_alarmdetail_execution(bigint, bigint, timestamp without time zone, date);
CREATE OR REPLACE FUNCTION public.center_insertnotificationservice_alarmdetail_execution(
    IN notificationno bigint,
    IN notificationservice_alarmdetailno bigint,
    IN regdate timestamp without time zone,
    IN executiondate date
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
