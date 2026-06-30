-- ─── FUNCTION: center_getservice_notificationservice_alarmdetail_execution ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_getservice_notificationservice_alarmdetail_execution(bigint);
CREATE OR REPLACE FUNCTION public.center_getservice_notificationservice_alarmdetail_execution(
    notificationservice_alarmdetailno bigint
) RETURNS TABLE(
    notificationservice_alarmdetail_execution bigserial,
    notificationno bigint,
    notificationservice_alarmdetailno bigint,
    regdate timestamp without time zone,
    executiondate date
)
AS $function$
BEGIN


	RETURN QUERY
	select * from Center_NotificationService_AlarmDetail_Execution
	where NotificationService_AlarmDetailNo = center_getservice_notificationservice_alarmdetail_execution.notificationservice_alarmdetailno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
