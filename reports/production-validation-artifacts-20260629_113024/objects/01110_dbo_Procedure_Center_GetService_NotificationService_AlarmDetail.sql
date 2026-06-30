-- ─── PROCEDURE→FUNCTION: center_getservice_notificationservice_alarmdetail ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.center_getservice_notificationservice_alarmdetail(bigint, date);
CREATE OR REPLACE FUNCTION public.center_getservice_notificationservice_alarmdetail(
    IN notificationno bigint,
    IN requestday date
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	select A.*,B.ExecutionDate from Center_NotificationService_AlarmDetail A
	left join Center_NotificationService_AlarmDetail_Execution B
	on A.NotificationService_AlarmDetailNo = B.NotificationService_AlarmDetailNo
	and B.ExecutionDate = center_getservice_notificationservice_alarmdetail.requestday
	where A.NotificationNo = center_getservice_notificationservice_alarmdetail.notificationno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
