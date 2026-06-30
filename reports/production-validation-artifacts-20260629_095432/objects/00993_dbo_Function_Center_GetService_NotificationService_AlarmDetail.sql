-- ─── FUNCTION: center_getservice_notificationservice_alarmdetail ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_getservice_notificationservice_alarmdetail(bigint, date);
CREATE OR REPLACE FUNCTION public.center_getservice_notificationservice_alarmdetail(
    notificationno bigint,
    requestday date
) RETURNS TABLE(
    col1 text,
    executiondate text
)
AS $function$
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
