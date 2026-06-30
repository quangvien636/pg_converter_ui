-- ─── PROCEDURE→FUNCTION: center_getservice_notificationservice_alarmdetail_execution ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.center_getservice_notificationservice_alarmdetail_execution(bigint);
CREATE OR REPLACE FUNCTION public.center_getservice_notificationservice_alarmdetail_execution(
    IN notificationservice_alarmdetailno bigint
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	select * from Center_NotificationService_AlarmDetail_Execution
	where NotificationService_AlarmDetailNo = center_getservice_notificationservice_alarmdetail_execution.notificationservice_alarmdetailno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
