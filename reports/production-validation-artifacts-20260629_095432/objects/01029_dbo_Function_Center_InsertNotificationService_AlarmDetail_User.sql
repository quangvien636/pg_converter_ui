-- ─── FUNCTION: center_insertnotificationservice_alarmdetail_user ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_insertnotificationservice_alarmdetail_user(bigint, bigint, integer, character varying, boolean);
CREATE OR REPLACE FUNCTION public.center_insertnotificationservice_alarmdetail_user(
    notificationno bigint,
    notificationservice_alarmdetailno bigint,
    userno integer,
    message character varying,
    state boolean
) RETURNS void
AS $function$
BEGIN


	INSERT INTO Center_NotificationService_AlarmDetail_User(NotificationNo,NotificationService_AlarmDetailNo,UserNo,Message,State)
	values(NotificationNo,NotificationService_AlarmDetailNo,UserNo,Message,State);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
